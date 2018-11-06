//
//  Engine.swift
//  Flisar
//
//  Created by Jordan Campbell on 2/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import UIKit
import ARKit
import JavaScriptCore

protocol EngineDelegate {
  func jsException(context: JSContext?, val: JSValue?) -> Void
}

class Engine: NSObject {
  
  static let instance = Engine()
  
  var delegate: EngineDelegate?
  private var context: JSContext!
  private let scripts = ["sdk"]
  private let jsQueue = DispatchQueue.init(label: Bundle.main.bundleIdentifier! + ".JSEngineQ",
                                           qos: .userInteractive)
  
  private var parent: MainVC!
  private var view: ARSCNView!
  var scene = Scene()
  
  let collisionThreshold: Float = 0.01
  var currentActiveScriptKey: String?
  
  private var launchLabel = VirtualLabel(theme: Constants.VirtualLabel.button_02, text: "Launch Menu")
  
  private var screenTapCallback: JSValue?
  private var logger = ARLogger()
  
  var jsExceptionCallback: ((_ context: JSContext?, _ val: JSValue?) -> Void)?
  
  private lazy var documents = {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }()
  
  private override init() {
    super.init()
    
    jsQueue.async {
      self.context = JSContext()
    }
  }
  
  var currCamTrackingState = ARCamera.TrackingState.notAvailable
  
  private struct JSException: Error, CustomStringConvertible {
    let exception: JSValue
    var description: String {
      return "\(exception)"
    }
    init(_ exception: JSValue) {
      self.exception = exception
    }
  }
  
  func setup(parent: MainVC, sceneView: ARSCNView) {
    self.parent = parent
    self.view = sceneView
    self.exposeInterfaceToJavascript()
    
    if let sdkScriptPath = Bundle.main.url(forResource: "sdk", withExtension: "js") {
      self.runScript(scriptPath: sdkScriptPath)
    }
    
//    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
//    self.view.addGestureRecognizer(gestureRecognizer)
    //    self.setupLaunchButton()
    //    self.setupLogger()
  }
  
  // refactor this
  func checkForMenuButtonTap(touchPosition:  CGPoint) -> Bool {
    if let nodeHitTestResult = self.view.hitTest(touchPosition, options: nil).first {
      if let name = nodeHitTestResult.node.name {
        if name == self.launchLabel.rootNode.name {
          return true
        }
      }
    }
    return false
  }
  
//  @objc private func handleSingleTap(recogniser: UITapGestureRecognizer) {
//    // Call the callback if any
//    let pt = recogniser.location(in: view)
//
//    // first check if we tapped on any UI nodes
//    if checkForMenuButtonTap(touchPosition: pt) {
//
//      self.launchLabel.click()
//
//    } else {
//      if let tapCb = self.screenTapCallback {
//        let tapHandler = TapHandler(touchPosition: pt, view: self.view)
//        jsQueue.async {
//          tapCb.call(withArguments: [tapHandler])
//        }
//      }
//    }
//  }
  
  private func setupLaunchButton() {
    self.launchLabel.rootNode.position = SCNVector3Make(0, 0, -1)
    
    self.launchLabel.onTap {
      if let parent = self.parent {
        parent.presentScriptVC()
      }
    }
  }
  
  private func setupLogger() {
    self.logger.position = SCNVector3Make(1, 0, -1)
    self.logger.eulerAngles.y -= 0.8
    self.scene.rootNode.addChildNode(self.logger)
  }
  
  private func exposeInterfaceToJavascript() {
    jsQueue.async {
      self.context.setObject(self.scene,
                             forKeyedSubscript: Constants.JSExp.scene as (NSCopying & NSObjectProtocol))
      self.context.setObject(self,
                             forKeyedSubscript: Constants.JSExp.mosaicoEngine as (NSCopying & NSObjectProtocol))
      
      // create a function that will be called when we call the js function '_consoleLog ( )'
      // need to use @convention( block ) to expose to js
      let consoleLog: @convention(block) (String) -> Void = { message in
        log.info("[ script ]: " + message )
        self.logger.addLog(message: "[ Mosaico ]: " + message)
      }
      
      // bind the function we just defined to the js equivalent
      self.context.setObject(unsafeBitCast(consoleLog, to: AnyObject.self),
                             forKeyedSubscript: "_consoleLog" as (NSCopying & NSObjectProtocol))
      
      // The default exception handler
      self.context.exceptionHandler = {(context: JSContext?, val: JSValue?) -> Void in
        // Perform default behaviour but also print out the error
        if let context = context {
          context.exception = val
        }
        
        if let val = val {
          log.error("JS exception: \(val)")
        }
        
        if let delegate = self.delegate {
          delegate.jsException(context: context, val: val)
        }
      }
    }
  }
  
  func updateColliderDetector() {
    self.scene.runColliderDetector()
  }
  
  // -----------------
  //     Hit Tests
  // -----------------
  func handleGesture(_touchPosition: CGPoint, _hitFeature: ARHitTestResult?, _hitNode: SCNNode?) {
    
    var args: Dictionary<String, AnyObject> = [:]
    args[Constants.JSExp.touchPosition] = [Float(_touchPosition.x), Float(_touchPosition.y)] as AnyObject
    
    if let feature = _hitFeature {
      let position = positionFromTransform(feature.worldTransform)
      args[Constants.JSExp.featureWorldTransform] = [position.x, position.y, position.z] as AnyObject
      
      jsQueue.async {
        _ = self.context.globalObject.invokeMethod(Constants.JSExp.featurePointTapped, withArguments: [args])
      }
    }
    
    // if a node was hit
    if let node = _hitNode {
      if let name = node.name {
        if name == self.launchLabel.rootNode.name {
          self.launchLabel.click()
        }
      }
    }
  }
  
  func isNull(value: JSValue) -> Bool {
    if let context = self.context {
      let contextref = context.jsGlobalContextRef
      let valueref = value.jsValueRef
      return JSValueIsNull(contextref, valueref)
    }
    return true
  }
}

// ----------------------
//     Initialisation
// ----------------------
extension Engine {
  
  func runScript(script: String, callback cb: ((_ err: Error?) -> Void)? = nil) {
    self.scene.removeSceneContent()
    jsQueue.async {
      self.context.evaluateScript(script)
      if let cb = cb { cb(nil) }
    }
  }
  
  func runScript(scriptPath: URL, callback cb: ((_ err: Error?) -> Void)? = nil) {
    do {
      
      self.scene.removeSceneContent()
      
      // Load its contents to a String variable.
      let source = try String(contentsOf: scriptPath)
      
      // Add the Javascript code that currently exists in the jsSourceContents
      // to the Javascript Runtime through the jsContext object
      jsQueue.async {
        self.context.evaluateScript(source)
        if let cb = cb {
          cb(nil)
        }
      }
    }
    catch {
      log.error(error.localizedDescription)
      if let cb = cb {
        cb(error)
      }
    }
  }
  
  func call(function: String, withArgs args: Dictionary<String, AnyObject>? = nil) {
    jsQueue.async {
      if let args = args {
        _ = self.context?.globalObject.invokeMethod(function , withArguments: [args])
      } else {
        _ = self.context?.globalObject.invokeMethod(function , withArguments: nil)
      }
    }
  }
}

extension Engine {
  private func isCameraStatusNormal() -> Bool {
    switch currCamTrackingState {
    case .normal:
      return true
    case .notAvailable, .limited:
      return false
    }
  }
}

extension Engine: MosaicoProtocol {
  /// Create a new Node object.
  func node() -> Node {
    return Node()
  }
  
  /// Create a new float3 object.
  func float3(_ x: Float, _ y: Float, _ z: Float) -> Float3 {
    return Float3(x, y, z)
  }
  
  /// Create a new SphereGeometry object.
  func sphereGeometry(_ radius: Float) -> SphereGeometry {
    return SphereGeometry(radius: CGFloat(radius))
  }
  
  /// Create a new PlaneGeometry object.
  func planeGeometry(_ width: Float, _ height: Float) -> PlaneGeometry {
    return PlaneGeometry(width: CGFloat(width), height: CGFloat(height))
  }
  
  /// Create a new CylinderGeometry object.
  func cylinderGeometry(_ radius: Float, _ height: Float) -> CylinderGeometry {
    return CylinderGeometry(radius: CGFloat(radius), height: CGFloat(height))
  }
  
  /// Create a new TorusGeometry object.
  func torusGeometry(_ ring: Float, _ pipe: Float) -> TorusGeometry {
    return TorusGeometry(ringRadius: CGFloat(ring), pipeRadius: CGFloat(pipe))
  }
  
  /// Create a new PyramidGeometry object.
  func pyramidGeometry(_ width: Float, _ height: Float, _ depth: Float) -> PyramidGeometry {
    return PyramidGeometry(width: CGFloat(width), height: CGFloat(height), length: CGFloat(depth))
  }
  
  /// Create a new ConeGeometry object.
  func coneGeometry(_ top: Float, _ bottom: Float, _ height: Float) -> ConeGeometry {
    return ConeGeometry(topRadius: CGFloat(top), bottomRadius: CGFloat(bottom), height: CGFloat(height))
  }
  
  /// Create a new TubeGeometry object.
  func tubeGeometry(_ inner: Float, _ outer: Float, _ height: Float) -> TubeGeometry {
    return TubeGeometry(innerRadius: CGFloat(inner), outerRadius: CGFloat(outer), height: CGFloat(height))
  }
  
  /// Create a new CubeGeometry object.
  func cubeGeometry(_ width: Float, _ height: Float, _ depth: Float, _ chamfer: Float) -> CubeGeometry {
    return CubeGeometry(width: CGFloat(width), height: CGFloat(height), length: CGFloat(depth), chamferRadius: CGFloat(chamfer))
  }
  
  /// Create a new Color object.
  func color(_ red: Float, _ green: Float, _ blue: Float, _ alpha: Float) -> Colour {
    return Colour( red, green, blue, alpha)
  }
  
  /// Import a glTF model and return it as a Node
  func importModel(_ filename: String) -> Node {
    return self.scene.importModel(filename: filename)
  }
  
  func setScreenTappedCallback(_ cb: JSValue) {
    screenTapCallback = cb
  }
}
