//
//  Geometry.swift
//  Flisar
//
//  Created by Jordan Campbell on 3/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import ARKit
import JavaScriptCore

@objc protocol GeometryProtocol: JSExport {
  func updateMaterial(_ material: Colour)
}

// It was hard to refactor the following code to be any less repetitive.

class CubeGeometry: SCNBox,  GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)  }
}

class ConeGeometry: SCNCone, GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)  }
  
}

class TubeGeometry: SCNTube, GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)  }
  
}

class PlaneGeometry: SCNPlane, GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)  }
  
}

class TorusGeometry: SCNTorus, GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)  }
  
}

class SphereGeometry: SCNSphere, GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)  }
  
}

class PyramidGeometry: SCNPyramid, GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)  }
}

class CylinderGeometry: SCNCylinder, GeometryProtocol {
  override func updateMaterial(_ material: Colour) {
    super.updateMaterial(material)
  }
}

extension SCNGeometry {
  /// Update the material attached to this geometry.
  @objc func updateMaterial(_ material: Colour) {
    self.firstMaterial?.diffuse.contents = material.colour
  }
}
