//
//  Float4.swift
//  Flisar
//
//  Created by Alberto Taiuti on 07/10/2018.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import Foundation

import SceneKit
import JavaScriptCore

@objc protocol Float4Protocol: JSExport {
  var x: Float { get set }
  var y: Float { get set }
  var z: Float { get set }
  var w: Float { get set }
  
  func add(_ b: Float4) -> Float4
  func sub(_ b: Float4) -> Float4
  func mul(_ b: Float4) -> Float4
  func div(_ b: Float4) -> Float4
  func mulScalar(_ b: Float) -> Float4
  func divScalar(_ b: Float) -> Float4
  func dot(_ b: Float4) -> Float
  func toUnit() -> Float4
  func toJSON() -> Dictionary<String, Any>

  /// Update the current x, y, z, w values.
  func set(_ x: Float, _ y: Float, _ z: Float, _ w: Float)
}

class Float4: NSObject, Float4Protocol {
  
  var data = simd_float4()
  
  convenience init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
    self.init(simd_float4(x, y, z, w))
  }
  
  required init(_ data: simd_float4) {
    super.init()
    self.data = data
  }
  
  var x: Float {
    get {
      return data.x
    }
    set {
      data.x = newValue
    }
  }
  
  var y: Float {
    get {
      return data.y
    }
    set {
      data.y = newValue
    }
  }
  
  var z: Float {
    get {
      return data.z
    }
    set {
      data.z = newValue
    }
  }
  
  var w: Float {
    get {
      return data.w
    }
    set {
      data.w = newValue
    }
  }
  
  /// Update the current x, y, z, values.
  func set(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
    self.data.x = x
    self.data.y = y
    self.data.z = z
    self.data.w = w
  }
  
  func add(_ b: Float4) -> Float4 {
    return Float4(data + b.data)
  }
  
  func sub(_ b: Float4) -> Float4 {
    return Float4(data - b.data)
  }
  
  func mul(_ b: Float4) -> Float4 {
    return Float4(data * b.data)
  }
  
  func div(_ b: Float4) -> Float4 {
    return Float4(data / b.data)
  }
  
  func mulScalar(_ b: Float) -> Float4 {
    return Float4(self.data * b)
  }
  
  func divScalar(_ b: Float) -> Float4 {
    return Float4(self.data / b)
  }
  
  func dot(_ b: Float4) -> Float {
    return Float(simd_dot(self.data, b.data))
  }
  
  func toUnit() -> Float4 {
    return Float4(simd_normalize(self.data))
  }
  
  func toJSON() -> Dictionary<String, Any> {
    return ["x" : data.x,
            "y" : data.y,
            "z" : data.z,
            "w" : data.w]
  }
}
