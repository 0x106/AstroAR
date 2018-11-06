//
//  CGPoint+Extensions.swift
//  Mosaico
//
//  Created by Alberto Taiuti on 10/10/2018.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import CoreGraphics
import simd

extension CGPoint {
  init(val: simd_float2) {
    self.init()
    self.x = CGFloat(val.x)
    self.y = CGFloat(val.y)
  }
}
