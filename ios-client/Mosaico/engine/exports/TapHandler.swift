//
//  TapHandler.swift
//  Mosaico
//
//  Created by Alberto Taiuti on 10/10/2018.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import UIKit
import ARKit
import JavaScriptCore

@objc protocol TapHandlerProtocol: JSExport {
  func getTouchPos() -> Float2
  func getNode() -> Node?
//  func getARPoint() -> Node?
}

class TapHandler: NSObject, TapHandlerProtocol {
  
  private let touchPos: CGPoint
  private let sceneView: ARSCNView
  
  init(touchPos: CGPoint, view: ARSCNView) {
    self.touchPos = touchPos
    self.sceneView = view
    
    super.init()
  }
  
  func getTouchPos() -> Float2 {
    return Float2(pt: touchPos)
  }
  
  func getNode() -> Node? {
    let touchPos = getTouchPos().toCGPoint()
    
    let nodeHitTestResult = self.sceneView.hitTest(touchPos, options: nil)
    
    if let node = nodeHitTestResult.first {
      let jsNode = node.node as! Node // We assume that any node added to the scene
                                 // is a Node type
      return jsNode
    }
    else {
      log.debug("Returning nil in getNode()")
      return nil
    }
  }
//
//  func getARPoint() -> Node? {
//    <#code#>
//  }
//
  
}
