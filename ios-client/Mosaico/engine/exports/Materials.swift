//
//  Materials.swift
//  Flisar
//
//  Created by Jordan Campbell on 3/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import ARKit
import JavaScriptCore

@objc protocol ColorProtocol: JSExport {}

// For some reason subclassing UIColor here doesn't
// play nicely.
// If you subclass and then create a colour object
// in js, then print it out - it gives you an object
// of type UIColorSomethingOrRather - i.e. the native
// type. All the other subclassed objects return the
// local type. 
class Colour: NSObject, ColorProtocol {
  
  var colour: UIColor
  
  required init(_ _red: Float, _ _green: Float, _ _blue: Float, _ _alpha: Float) {
    self.colour = UIColor(red: CGFloat(_red), green: CGFloat(_green), blue: CGFloat(_blue), alpha: CGFloat(_alpha))
  }
}
