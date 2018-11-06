//
//  Float4x4.swift
//  Flisar
//
//  Created by Alberto Taiuti on 07/10/2018.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import SceneKit
import JavaScriptCore

@objc protocol Float4x4Protocol: JSExport {
  var columns: [Float4] { get set }
  func setColumn(_ index: Int, _ value: Float4)
  
  func add(_ b: Float4x4) -> Float4x4
  func sub(_ b: Float4x4) -> Float4x4
  func mul(_ b: Float4x4) -> Float4x4
  
  func determinant() -> Float
  func transpose() -> Float4x4
  func inverse() -> Float4x4
}


@objc class Float4x4: NSObject, Float4x4Protocol {
  
  var data = simd_float4x4()
  
  required init(_ matrix: simd_float4x4) {
    super.init()
    data = matrix
  }
  
  convenience init(_ columns: [Float4]) {
    self.init(simd_float4x4(columns[0].data, columns[1].data, columns[2].data,
                           columns[4].data))
  }
  
  var columns: [Float4] {
    get {
      return [Float4(data.columns.0),
              Float4(data.columns.1),
              Float4(data.columns.2),
              Float4(data.columns.3)]
    }
    set {
      data.columns.0 = newValue[0].data
      data.columns.1 = newValue[1].data
      data.columns.2 = newValue[2].data
      data.columns.3 = newValue[3].data
    }
  }
  
  func setColumn(_ index: Int, _ value: Float4) {
    assert(0 <= index && 3 >= index, "Index must be between 0 and 3")
    
    switch index {
    case 0:
      data.columns.0 = value.data
    case 1:
      data.columns.1 = value.data
    case 2:
      data.columns.2 = value.data
    case 3:
      data.columns.3 = value.data
    default:
      return
    }
  }
  
  func mul(_ b: Float4x4) -> Float4x4 {
    return Float4x4(simd_mul(data, b.data))
  }
  
  func add(_ b: Float4x4) -> Float4x4 {
    return Float4x4(simd_add(data, b.data))
  }
  
  func sub(_ b: Float4x4) -> Float4x4 {
    return Float4x4(simd_sub(data, b.data))
  }
  
  func determinant() -> Float {
    return Float(simd_determinant(data))
  }
  
  func transpose() -> Float4x4 {
    return Float4x4(simd_transpose(data))
  }
  
  func inverse() -> Float4x4 {
    return Float4x4(simd_inverse(data))
  }
}
