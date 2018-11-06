//
//  ViewController.swift
//  Flisar
//
//  Created by Jordan Campbell on 2/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import JavaScriptCore

class MainVC: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

  @IBOutlet var sceneView: ARSCNView!

  var scriptToExecute: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set the view's delegate
    sceneView.delegate = self
    sceneView.session.delegate = self

    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
    UIApplication.shared.isIdleTimerDisabled = true

    // ---------------------------------------------------
    Engine.instance.setup(parent: self, sceneView: sceneView)
    Engine.instance.delegate = self
    self.sceneView.scene = Engine.instance.scene
    // ---------------------------------------------------
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()

    // Run the view's session
    sceneView.session.run(configuration)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.runScriptInARContext()
  }

  func runScriptInARContext() {
    if let script = self.scriptToExecute {
      Engine.instance.runScript(script: script) { _ in
        log.debug("Finished running script \(script)")
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Pause the view's session
    sceneView.session.pause()
  }

  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    Engine.instance.updateColliderDetector()
  }
}

// Gesture recognisers
extension MainVC {

  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    Engine.instance.currCamTrackingState = camera.trackingState
  }

  func presentScriptVC() {

    let mainStoryBoard = UIStoryboard(name: Constants.StoryboardsIDs.main, bundle: nil)
    guard let vc: ScriptVC = instVC(withIdentifier: Constants.VCIDs.script, storyBoard: mainStoryBoard) else {
      return
    }

    self.show(vc, sender: self)
  }

  @IBAction func onScriptsBtnTouchUpInside(_ sender: Any) {
    presentScriptVC()
  }
}

extension MainVC: EngineDelegate {
  func jsException(context: JSContext?, val: JSValue?) {
    guard let val = val else {
      return
    }

    // Show popup
    let alertView = UIAlertController(title: "JS exception", message: "\(val)", preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
      // Go back to list of scripts
      DispatchQueue.main.async {
        self.presentScriptVC()
      }
    }))

    DispatchQueue.main.async {
      self.present(alertView, animated: true, completion: nil)
    }
  }
}
