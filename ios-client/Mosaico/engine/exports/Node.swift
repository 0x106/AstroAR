//
//  Node.swift
//  Flisar
//
//  Created by Jordan Campbell on 2/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import SceneKit
import JavaScriptCore

@objc protocol NodeProtocol: JSExport {
  
  func add(_ child: Node)
  func updatePosition(_ value: Float3)
  func updateRotation (_ value: Float3)
  func updateScale (_ value: Float3)
  func updateOpacity(_ opacity: Float)
  func updateGeometry(_ geometry: SCNGeometry)
  func updateMaterial(_ material: Colour)
  func localTranslation(_ value: Float3)
  
  func animateRotation(_ value: Float3, _ duration: Double, _ onComplete: JSValue)
  func animatePosition(_ value: Float3, _ duration: Double, _ onComplete: JSValue)
  func animateScale(_ value: Float, _ duration: Double, _ onComplete: JSValue)
  func animateOpacity(_ value: Float, _ duration: Double, _ onComplete: JSValue)
  func animateLocalTranslation(_ value: Float3, _ duration: Double, _ onComplete: JSValue)
  
  var children: [Node] { get }
  var localPosition: Float3 { get }
  var localRotation: Float3 { get }
  var localScale: Float3 { get }
  var localTransform: Float4x4 { get set }
  
  func setCollisionDetector(_ cb: JSValue)
}

class Node: SCNNode, NodeProtocol {
  
  // We can define functions inside our js code that we want to execute whenever this
  // node collides with any other node.
  private var collisionDetectionCallback: JSValue?
  
  required override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Add a new node to the scene graph.
  func add(_ child: Node) {
    self.addChildNode(child)
  }
  
  /// The current position of this node relative to its parent
  var localPosition: Float3 {
    get {
      return Float3(self.simdPosition.x, self.simdPosition.y, self.simdPosition.z)
    }
  }
  
  /// The current rotation of this node relative to its parent (euler angles)
  var localRotation: Float3 {
    get {
      return Float3(self.simdEulerAngles.x, self.simdEulerAngles.y, self.simdEulerAngles.z)
    }
  }
  
  /// The current scale of this node relative to its parent
  var localScale: Float3 {
    get {
      return Float3(self.simdScale.x, self.simdScale.y, self.simdScale.z)
    }
  }
  
  /// A list of the current child Nodes attached to this node.
  var children: [Node] {
    get {
      if let nodes = self.childNodes as? [Node] {
        return nodes
      }
      return []
    }
  }
  
  var localTransform: Float4x4 {
    get {
      return Float4x4(simdTransform)
    }
    set {
      simdTransform = newValue.data
    }
  }
  
  var importedModelReferenceKey: String?
  
  /// Set this nodes' position value relative to its parent
  func updatePosition (_ value: Float3) {
    self.simdPosition = value.data
  }
  
  /// Set this nodes' rotation value
  func updateRotation (_ value: Float3) {
    self.simdEulerAngles = value.data
  }
  
  /// Set this nodes' scale value
  func updateScale (_ value: Float3) {
    self.simdScale = value.data
  }
  
  /// Set this nodes' opacity value
  func updateOpacity(_ opacity: Float) {
    self.opacity = CGFloat(opacity)
  }
  
  /// Set this nodes' geometry
  func updateGeometry(_ geometry: SCNGeometry) {
    self.geometry = geometry
  }
  
  /// Set this nodes' geometrys' material
  func updateMaterial(_ material: Colour) {
    self.geometry?.firstMaterial?.diffuse.contents = material.colour
  }
  
  /// Translate this node according to its local transform
  func localTranslation(_ value: Float3) {
    self.simdLocalTranslate(by: value.data)
  }
  
  // don't use this for now
  // Allows generic animations on any (animatable) property
  private func animate(_ node: SCNNode, _ path: String, from: Any, to: Any, during: CFTimeInterval) {
    let animation = CABasicAnimation(keyPath: path)
    animation.fromValue = from
    animation.toValue = to
    animation.duration = during
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.isRemovedOnCompletion = false
    node.addAnimation(animation, forKey: nil)
  }
  
  private func run(animation: SCNAction, onComplete: JSValue) {
    let isNull = Engine.instance.isNull(value: onComplete)
    if isNull {
      self.runAction(animation)
    } else {
      self.runAction(animation) {
        onComplete.call(withArguments: nil)
      }
    }
  }
}



// Animation API
extension Node {
  func animateRotation(_ value: Float3, _ duration: Double, _ onComplete: JSValue) {
    
    let animation = SCNAction.rotateBy(x: CGFloat(value.data[0]),
                                       y: CGFloat(value.data[1]),
                                       z: CGFloat(value.data[2]),
                                       duration: duration)
    self.run(animation: animation, onComplete: onComplete)
  }
  
  func animatePosition(_ value: Float3, _ duration: Double, _ onComplete: JSValue) {
    let animation = SCNAction.moveBy(x: CGFloat(value.data[0]),
                                     y: CGFloat(value.data[1]),
                                     z: CGFloat(value.data[2]),
                                     duration: duration)
    self.run(animation: animation, onComplete: onComplete)
  }
  
  func animateScale(_ value: Float, _ duration: Double, _ onComplete: JSValue) {
    let animation = SCNAction.scale(to: CGFloat(value), duration: duration)
    self.run(animation: animation, onComplete: onComplete)
  }
  
  func animateOpacity(_ value: Float, _ duration: Double, _ onComplete: JSValue) {
    let animation = SCNAction.fadeOpacity(to: CGFloat(value), duration: duration)
    self.run(animation: animation, onComplete: onComplete)
  }
  
  func animateLocalTranslation(_ value: Float3, _ duration: Double, _ onComplete: JSValue) {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = duration
    self.simdLocalTranslate(by: value.data)
    SCNTransaction.commit()
    let isNull = Engine.instance.isNull(value: onComplete)
    if !isNull {
      SCNTransaction.completionBlock = {
        onComplete.call(withArguments: nil)
      }
    }
  }
  
  
  /// Animate a change in rotation relative to its parent node
  ///
  /// This moves the node _by_ the specified amount
  /// Calls the onComplete function when finished.
  
  /// Animate a change in position relative to its parent node
  ///
  /// This moves the node _by_ the specified amount
  /// Calls the onComplete function when finished.

  
  /// Animate a change in scale
  ///
  /// This rotates the node _to_ the specified value
  /// Calls the onComplete function when finished.
  
  /// Animate a change in scale
  ///
  /// This rotates the node _to_ the specified value
  /// Calls the onComplete function when finished.
  
  /// Animate a translation in the local coordinate space.
  ///
  /// This translates the node from its current position _by_ the
  /// specified value, according to its current transform value.
  /// Calls the onComplete function when finished.
}

extension Node {
  
  func emitCollision(rhs: Node) {
    if let cb = self.collisionDetectionCallback {
      cb.call(withArguments: [rhs])
    }
  }
  
  func setCollisionDetector(_ cb: JSValue) {
    self.collisionDetectionCallback = cb
  }
  
}
