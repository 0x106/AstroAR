//
//  Float3.swift
//  Flisar
//
//  Created by Jordan Campbell on 3/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import SceneKit
import JavaScriptCore

@objc protocol Float3Protocol: JSExport {
  var x: Float { get set }
  var y: Float { get set }
  var z: Float { get set }
  
  func add(_ b: Float3) -> Float3
  func sub(_ b: Float3) -> Float3
  func mul(_ b: Float3) -> Float3
  func div(_ b: Float3) -> Float3
  func mulScalar(_ b: Float) -> Float3
  func divScalar(_ b: Float) -> Float3
  func dot(_ b: Float3) -> Float
  func cross(_ b: Float3) -> Float3
  func toUnit() -> Float3
  func toJSON() -> Dictionary<String, Any>
  
  /// Update the current x, y, z, values.
  func set(_ x: Float, _ _: Float, _ z: Float)
}

class Float3: NSObject, Float3Protocol {

  var data = simd_float3()
  
  convenience init(_ x: Float, _ y: Float, _ z: Float) {
    self.init(simd_float3(x, y, z))
  }
  
  required init(_ data: simd_float3) {
    super.init()
    self.data = data
  }
  
  var x: Float {
    get {
      return data.x
    }
    set {
      self.data.x = newValue
    }
  }
  
  var y: Float {
    get {
      return data.y
    }
    set {
      self.data.y = newValue
    }
  }
  
  var z: Float {
    get {
      return data.z
    }
    set {
      self.data.z = newValue
    }
  }
  
  func set(_ x: Float, _ y: Float, _ z: Float) {
    self.data.x = x
    self.data.y = y
    self.data.z = z
  }
  
  func add(_ b: Float3) -> Float3 {
    return Float3(data + b.data)
  }
  
  func sub(_ b: Float3) -> Float3 {
    return Float3(data - b.data)
  }
  
  func mul(_ b: Float3) -> Float3 {
    return Float3(data * b.data)
  }
  
  func div(_ b: Float3) -> Float3 {
    return Float3(data / b.data)
  }
  
  func mulScalar(_ b: Float) -> Float3 {
    return Float3(self.data * b)
  }
  
  func divScalar(_ b: Float) -> Float3 {
    return Float3(self.data / b)
  }
  
  func dot(_ b: Float3) -> Float {
    return Float(simd_dot(self.data, b.data))
  }
  
  func cross(_ b: Float3) -> Float3 {
    return Float3(simd_cross(self.data, b.data))
  }
  
  func toUnit() -> Float3 {
    return Float3(simd_normalize(self.data))
  }
  
  func toJSON() -> Dictionary<String, Any> {
    return ["x" : data.x,
            "y" : data.y,
            "z" : data.z]
  }
}
