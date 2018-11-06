//
//  Scene.swift
//  Flisar
//
//  Created by Jordan Campbell on 2/10/18.
//  Copyright © 2018 Mosaico. All rights reserved.
//

import SceneKit
import JavaScriptCore
import GLTFSceneKit
import FirebaseDatabase
import Zip

// ------------------------------------------------------
/// SceneProtocol
///
/// Expose the Scene object to Javascript
@objc protocol SceneProtocol: JSExport {
  func add( _ node: Node )
  var nodes: [Node] { get }
}

class Scene: SCNScene, SceneProtocol {
  
  var sceneContent = Node()
  
  private lazy var database = {
    return Database.database().reference()
  }()
  
  private lazy var documents = {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }()
  
  private let loadGLTFQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".loadGLTFQueue",
                                              qos: .userInteractive)

  private let collisionQueue = DispatchQueue.init(label: Bundle.main.bundleIdentifier! + ".collisionQueue",
                                                  qos: .userInteractive)
  
  /// A list of nodes currently in the scene graph.
  var nodes: [Node] {
    get {
      if let nodes = self.sceneContent.childNodes as? [Node] {
        return nodes
      }
      return []
    }
  }
  
  var importedModelsList = Dictionary<String, Node>()
  
  override init() {
    super.init()
    self.rootNode.addChildNode(self.sceneContent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Add a new node to the scene graph.
  func add (_ node: Node) {
    
    if let referenceKey = node.importedModelReferenceKey {
      if let importedNode = self.importedModelsList[referenceKey] {
        node.add(importedNode)
      }
    }
    
    self.sceneContent.add(node)
  }
  
  func removeSceneContent() {
    for node in self.sceneContent.childNodes {
      node.removeFromParentNode()
    }
  }
}

extension Scene {
  
  func importModel(filename: String) -> Node {
    
    let node = Node()
    let key = UUID().uuidString
    node.importedModelReferenceKey = key
    
    self.getNode(filename: filename) { [weak self] gltfNode in
      guard let self_ = self else { return }
      
      self_.importedModelsList[ key ] = gltfNode
      
      // check whether this node is already part of the scene
      for child in self_.sceneContent.children {
        if let referenceKey = child.importedModelReferenceKey {
          if key == referenceKey {
            child.addChildNode( gltfNode.childNodes[0] )
            self_.importedModelsList.removeValue(forKey: key)
          }
        }
      }
    }
    
    return node
  }
  
  func getNode(filename: String, callback: @escaping (Node) -> ()) {
    
    self.requestModelFromStorage(key: filename) { filePath in
      self.loadGLTFQueue.async {
        
        let node = Node()
        
        do {
          let unzipDirectory = try Zip.quickUnzipFile(filePath)
          
          // 3. Load contents as model
          let sceneSource = try GLTFSceneSource(path: unzipDirectory.path + "/scene.gltf")
          let scene = try sceneSource.scene()
          
          // need to manually transfer all the children - this will actually only
          // be about one node, moved by reference so fast.
          for n in scene.rootNode.childNodes {
            node.addChildNode(n)
          }
          
          callback(node)
        
        }
        catch {
          log.error("Something went wrong")
        }
      }
    }
  }
  
  func requestModelFromStorage(key: String, callback: @escaping (URL) -> () ) {
//    let filename = "\(key).zip"
//    let reference = self.storage.child(filename)
//    let modelLocalURL = self.documents.appendingPathComponent(filename)
//
//    // firebase downloads always need to be on the main queue
//    // explicitly move them to main now in case we have launched
//    // a separate thread somewhere
//    DispatchQueue.main.async {
//      reference.write(toFile: modelLocalURL) { url, error in
//        if let error = error {
//          log.error(error)
//        } else {
//          callback(modelLocalURL)
//        }
//      }
//    }
    
  }
  
  // this function is *very inefficient* (TM), however in reality it is perfectly
  // fine, since scenes are going to be small. Moreover, it took literally 5 minutes
  // to write and provides really nice functionality -- so for now it stays.
  // Doing collision detections properly would (likely) require accessing physics bodies
  // on the nodes, which may or may not be trivial.
  func runColliderDetector() {
    collisionQueue.async {
      // for each node see if it's within a threshold of any other node
      for nA in 0 ..< self.sceneContent.children.count {
        for nB in 0 ..< self.sceneContent.children.count {
          if nA != nB {
            
            let lhs = self.sceneContent.children[nA]
            let rhs = self.sceneContent.children[nB]
            
            let distance = simd_distance(lhs.simdPosition, rhs.simdPosition)
            if distance < Engine.instance.collisionThreshold {
              lhs.emitCollision(rhs: rhs)
            }
          }
        }
      }
    }
  }
}
