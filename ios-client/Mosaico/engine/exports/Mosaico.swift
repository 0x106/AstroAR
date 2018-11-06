//
//  Mosaico.swift
//  Flisar
//
//  Created by Jordan Campbell on 3/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import SceneKit
import JavaScriptCore

@objc protocol MosaicoProtocol: JSExport {
  func node() -> Node
  func float3(_ x: Float, _ y: Float, _ z: Float) -> Float3
  func sphereGeometry(_ radius: Float) -> SphereGeometry
  func planeGeometry(_ width: Float, _ height: Float) -> PlaneGeometry
  func torusGeometry(_ ring: Float, _ pipe: Float) -> TorusGeometry
  func cylinderGeometry(_ radius: Float, _ height: Float) -> CylinderGeometry
  func pyramidGeometry(_ width: Float, _ height: Float, _ depth: Float) -> PyramidGeometry
  func coneGeometry(_ top: Float, _ bottom: Float, _ height: Float) -> ConeGeometry
  func cubeGeometry(_ width: Float, _ height: Float, _ depth: Float, _ _chamfer: Float) -> CubeGeometry
  func tubeGeometry(_ inner: Float, _ outer: Float, _ height: Float) -> TubeGeometry
  func color(_ red: Float, _ green: Float, _ blue: Float, _ alpha: Float) -> Colour
  func importModel(_ filename: String) -> Node
//  func setScreenTappedCallback(_ cb: JSValue)
}

