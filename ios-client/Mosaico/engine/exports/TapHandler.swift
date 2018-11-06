//
//  TapHandler.swift
//  Mosaico
//
//  Created by Jordan Campbell on 10/10/2018.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import UIKit
import ARKit
import JavaScriptCore

@objc protocol TapHandlerProtocol: JSExport {
  func getTouchPosition() -> Float2
  func getNode() -> Node?
}

class TapHandler: NSObject, TapHandlerProtocol {
  
  private let touchPosition: CGPoint
  private let sceneView: ARSCNView
  
  init(touchPosition: CGPoint, view: ARSCNView) {
    self.touchPosition = touchPosition
    self.sceneView = view
    
    super.init()
  }
  
  func getTouchPosition() -> Float2 {
    return Float2(pt: touchPosition)
  }
  
  func getNode() -> Node? {
    let touchPosition = getTouchPosition().toCGPoint()
    
    let nodeHitTestResult = self.sceneView.hitTest(touchPosition, options: nil)
    
    if let node = nodeHitTestResult.first {
      if let jsNode = node.node as? Node {
        return jsNode
      }
      
      log.debug("Could not retrieve js node for hit test")
      return nil
    }
    else {
      log.debug("Could not retrieve js node for hit test")
      return nil
    }
  }

}
