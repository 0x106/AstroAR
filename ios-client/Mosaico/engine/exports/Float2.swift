//
//  Float2.swift
//  Mosaico
//
//  Created by Alberto Taiuti on 10/10/2018.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import Foundation

import SceneKit
import JavaScriptCore

@objc protocol Float2Protocol: JSExport {
  var x: Float { get set }
  var y: Float { get set }
  
  func add(_ b: Float2) -> Float2
  func sub(_ b: Float2) -> Float2
  func mul(_ b: Float2) -> Float2
  func div(_ b: Float2) -> Float2
  func mulScalar(_ b: Float) -> Float2
  func divScalar(_ b: Float) -> Float2
  func dot(_ b: Float2) -> Float
  func toUnit() -> Float2
  func toJSON() -> Dictionary<String, Any>
  
  /// Update the current x, y, z, w values.
  func set(_ x: Float, _ y: Float)
}

class Float2: NSObject {
  
  private var data = simd_float2()
  
  required init(_ data: simd_float2) {
    super.init()
    self.data = data
  }
  
  convenience init(_ x: Float, _ y: Float) {
    self.init(simd_float2(x, y))
  }
  
  convenience init(pt: CGPoint) {
    self.init(Float(pt.x), Float(pt.y))
  }
  
  func toCGPoint() -> CGPoint {
    return CGPoint(val: data)
  }
}

extension Float2: Float2Protocol {
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
  
  /// Update the current x, y, z, values.
  func set(_ x: Float, _ y: Float) {
    self.data.x = x
    self.data.y = y
  }
  
  func add(_ b: Float2) -> Float2 {
    return Float2(data + b.data)
  }
  
  func sub(_ b: Float2) -> Float2 {
    return Float2(data - b.data)
  }
  
  func mul(_ b: Float2) -> Float2 {
    return Float2(data * b.data)
  }
  
  func div(_ b: Float2) -> Float2 {
    return Float2(data / b.data)
  }
  
  func mulScalar(_ b: Float) -> Float2 {
    return Float2(self.data * b)
  }
  
  func divScalar(_ b: Float) -> Float2 {
    return Float2(self.data / b)
  }
  
  func dot(_ b: Float2) -> Float {
    return Float(simd_dot(self.data, b.data))
  }
  
  func toUnit() -> Float2 {
    return Float2(simd_normalize(self.data))
  }
  
  func toJSON() -> Dictionary<String, Any> {
    return ["x" : data.x,
             "y" : data.y]
  }
}
