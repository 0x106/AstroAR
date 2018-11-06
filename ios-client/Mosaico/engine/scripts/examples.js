
function boilerPlateNode() {
  var node = Mosaico.node()
  var geometry = Mosaico.cubeGeometry(0.1, 0.1, 0.1, 0.01)
  var material = Mosaico.color( 1, 0, 1, 1.0 )
  geometry.updateMaterial( material )
  node.updateGeometry(geometry)
  
  var position = Mosaico.float3(0, 0, -1)
  node.updatePosition(position)
  return node
}





function example_01() {
  console.log( "---- example 01 ----" )
  
  // scene & Mosaico are defined by Swift
  console.log(scene)
  console.log(Mosaico)
  
  var node = Mosaico.node()
  var position = Mosaico.float3(1, 2.0, 3.0)
  
  // node is an object we create
  console.log(node)
  console.log(position)
  
  node.updatePosition(position)
  
  scene.add( node )
  
  console.log("scene children")
  console.log(scene.nodes.length)
  console.log(scene.nodes[0].localPosition.x)
  console.log(scene.nodes[0].localPosition.y)
  console.log(scene.nodes[0].localPosition.z)
}






function example_02() {
  console.log( "---- example 02 ----" )
  
  var node = Mosaico.node()
  var cube = Mosaico.cubeGeometry(0.1, 0.1, 0.1, 0.01)
  var sphere = Mosaico.sphereGeometry(0.1)
  var plane = Mosaico.planeGeometry(0.1, 0.1)

  node.updateGeometry(plane)
  
  node.updatePosition( Mosaico.float3(0, 0, -1) )
  scene.add(node)
}






function example_03() {
  console.log( "---- example 03----" )
  
  var node = Mosaico.node()
  var geometry = Mosaico.cubeGeometry(0.1, 0.1, 0.1, 0.01)
  
  // r, g, b
  // add support for hex later
  var material = Mosaico.color( 1, 0, 1, 0.5 )
  console.log(material)
  console.log(geometry)
  
  geometry.updateMaterial( material )
  
  node.updateGeometry(geometry)
  
  node.updatePosition( Mosaico.float3(0, 0, -1) )
  scene.add(node)
}






function example_04() {
  console.log( "---- example 04 ----" )
  
  var node = boilerPlateNode()
  
  var translation = Mosaico.float3(0.25, 0, 0)
  node.localTranslation(translation)
  
  var rotation = Mosaico.float3(0, 0, 1.57)
  node.updateRotation(rotation)
  
  console.log("position")
  console.log(node.localPosition.x)
  console.log(node.localPosition.y)
  console.log(node.localPosition.z)
  
  console.log("rotation")
  console.log(node.localRotation.x)
  console.log(node.localRotation.y)
  console.log(node.localRotation.z)
  
  node.localTranslation(translation)
  console.log("-----------")
  console.log(node.localPosition.x)
  console.log(node.localPosition.y)
  console.log(node.localPosition.z)
  
  scene.add( node )
}







// A choose-your-own-animation game.
// TODO: Probably worth checking all the
// anim naming conventions - some of them
// are _by_ a value and some are _to_ a
// value.
function example_05 () {
  console.log( "---- example 05 ----" )
  var node = boilerPlateNode()
  scene.add(node)
  
  var duration = 4.0
  
  // animate global position
  if (false) {
    var newPosition = Mosaico.float3(0.5, 0.5, -1)
    node.animatePosition(newPosition, duration)
  }
  
  // animate (local) rotation
  if (false) {
    var newRotation = Mosaico.float3(0, 6.28, 0)
    node.animateRotation(newRotation, duration)
  }
  
  // animate scale
  if (false) {
    var newScale = 0.1
    node.animateScale(newScale, duration)
  }
  
  // animate opacity
  if (false) {
    var newOpacity = 0.1
    node.animateOpacity(newOpacity, duration)
  }
  
  // animate local translation
  if (true) {
    
    console.log(node)
    
    var translation = Mosaico.float3(2.0, 0, 0)
    var rotation = Mosaico.float3(0, 1.57, 0)
    
    // rotate the node first, to show that updating the local
    // position takes into account the current orientation
    node.updateRotation(rotation)
    node.animateLocalTranslation(translation, duration*10)
  }
}


// test new float3 interface
function example_06() {

  var vector = Mosaico.float3(1, 2, 3)
  console.log(vector.x)
  
  vector.x = 10
  
  console.log(vector.x)
  
  var newVector = vector.get()
  
  console.log(newVector[0])
  
}

// will no longer work
function example_07() {
  
  var node = Mosaico.node()
  
  console.log(node.testPosition.x)
  
  node.testPosition.x = 10
  
  console.log(node.testPosition.x)
  
  var pos = node.getTestPosition()
  
  console.log(pos[0])
  
}

// didn't work
function example_08() {
  
  var node = Mosaico.node()
  
  console.log(node.localPosition.x)
  
  node.localPosition.x = 10
  
  node.localPosition = {x:10}
  
  console.log(node.localPosition.x)
  
  var pos = node.getlocalPosition()
  
  console.log(pos[0])
  
}

function example_09() {
  
  var n1 = boilerPlateNode()
  var n2 = boilerPlateNode()
  
  var material = Mosaico.color( 0, 0, 1, 1.0 )
  var position = Mosaico.float3(1, 0, -1)
  
  n2.updateMaterial(material)
  n2.updatePosition(position)
  
  n1.add(n2)
  
  scene.add(n1)
  
}

function gltf_example() {
  // import models
  
  var model = Mosaico.importModel("-LOBM82ZwZTpruAalOtT")
  var position = Mosaico.float3(0, 0, -2.0)
  var scale = Mosaico.float3(0.01, 0.01, 0.01)
  
  model.updateScale(scale)
  model.updatePosition(position)
  
  scene.add(model)

}


function animationCompletion() {
  console.log("Animation completed")
}

function handleTap(tapHandler) {
  console.log("Tap handler")

  console.log(tapHandler)
  
  let touchPos = tapHandler.getTouchPos()
  console.log(touchPos)
  console.log(touchPos.toJSON().x)
  
  let node = tapHandler.getNode()
  console.log(node)
}

function collisionCallback( node ) {
  console.log("Collision detected")
  console.log(node.localPosition.x)
}

function collision_example() {
  var nodeA = boilerPlateNode()
  var nodeB = boilerPlateNode()
  
  var pA = Mosaico.float3(0, 0, -1)
  var pB = Mosaico.float3(-1, 0, -1)

  nodeA.setCollisionDetector(collisionCallback)
  
  nodeA.updatePosition(pA)
  nodeB.updatePosition(pB)
  
  scene.add(nodeA)
  scene.add(nodeB)
  
  var target = Mosaico.float3(3, 0, 0)
  var duration = 7.0
  
  nodeB.animatePositionCB(target, duration, function () {
                        console.log("animate callback")
                        })
//  nodeB.animateRotation(target, duration)
//  nodeB.animateScale(0.1, duration)
//  nodeB.animateOpacity(0.1, duration)
  
//  nodeB.updateRotation(Mosaico.float3(0.34, 8.2, 10.0))
//  nodeB.animateLocalTranslation(target, duration)
}

function animation_example() {
  Mosaico.setScreenTappedCallback(handleTap)
}

collision_example()








//
