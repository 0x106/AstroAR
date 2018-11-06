//
//  AppDelegate.swift
//  Mosaico
//
//  Created by Jordan Campbell on 2/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import UIKit
import Firebase
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let console = ConsoleDestination()  // log to Xcode Console
    console.format = "[Mosaico]$d $L $M"
    console.levelString.debug  = "🤖"
    console.levelString.info = "🛰"
    console.levelString.error = "☠️"
    log.addDestination(console)
    
    FirebaseApp.configure()
    
    return true
  }
}

