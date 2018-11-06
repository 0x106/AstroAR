//
//  Constants.swift
//  Flisar
//
//  Created by Jordan Campbell on 2/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import Foundation


struct Constants {
  // Dummy for now; update with real values once Alberto gets access to the
  // firebase project and can create the twitter app
  struct APIKeys {
    struct TwitterConsumer {
      static let api = "GzJ6AalWIhr6Wirxul0ExtKcd"
      static let secret = "NsguixBUwOkJ3lMXAb9mGBaJY05lGMJEQoymZ2mf113WDMhMgH"
    }
  }
  
  /// Names to expose to the JS context
  struct JSExp {
    static let mosaicoEngine = "Mosaico"
    static let node = "Node"
    static let scene = "scene"
    static let touchPosition = "touchPosition"
    static let featurePointTapped = "featurePointTapped"
    static let featureWorldTransform = "featureWorldTransform"
  }
  
  struct Animation {
    static let property = "property"
    
    static let opacity = "opacity"
    static let position = "position"
    static let rotation = "rotation"
    static let scale = "scale"
    static let colour = "colour"
    
    static let duration = "duration"
    static let value = "value"
  }
  
  struct VCIDs {
    static let splash = "SplashVC"
    static let main = "MainVC"
    static let login = "LoginVC"
    static let script = "ScriptVC"
  }
  
  struct StoryboardsIDs {
    static let main = "Main"
  }
  
  struct VirtualLabel {
    static let button = "button"
    static let button_02 = "button_02"
  }
  
  struct TableView {
    static let cell = "ModelCell"
  }
  
  struct Firebase {
    static let scripts = "scripts"
  }
  
  static let undefined = "undefined"
}
