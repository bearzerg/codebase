import SceneKit

class GameController: NSObject, SCNSceneRendererDelegate {
  
  
  var scene: SCNScene!
  var bracket: SCNNode!
  var pointer: SCNNode!
  let sceneRenderer: SCNSceneRenderer
  
  init(sceneRenderer renderer: SCNSceneRenderer) {
    sceneRenderer = renderer
    super.init()
    
    guard let scene = SCNScene(named: "game.scn", inDirectory: "art.scnassets", options: nil) else { return }
    scene.physicsWorld.contactDelegate = self
    
    bracket = scene.rootNode.childNode(withName: "bracketContainer", recursively: false) ?? SCNNode()
    pointer = scene.rootNode.childNode(withName: "pointer", recursively: false) ?? SCNNode()
    
    let distanceConstraint = SCNDistanceConstraint(target: pointer)
    distanceConstraint.minimumDistance = 0.1
    //        distanceConstraint.influenceFactor = 0.5
    
    let lookAtConstraint = SCNLookAtConstraint(target: pointer)
    lookAtConstraint.influenceFactor = 0.8
    //        lookAtConstraint.isIncremental = false
    lookAtConstraint.targetOffset.x = -.pi / 2
    lookAtConstraint.targetOffset.y = .pi / 2
    lookAtConstraint.isGimbalLockEnabled = true
    
    
    let accelerationConstraint = SCNAccelerationConstraint()
    accelerationConstraint.maximumLinearVelocity = 30
    accelerationConstraint.maximumLinearAcceleration = 300
    accelerationConstraint.damping = 0.1
    //        accelerationConstraint.decelerationDistance = 2
    
    
    
    bracket.constraints = [
      //            distanceConstraint,
      accelerationConstraint,
      //            replicatorConstraint,
      //            lookAtConstraint
    ]
    
    bracket.childNodes.forEach { (node) in
      //            node.constraints = [accelerationConstraint]
    }
    
    self.scene = scene
    scene.physicsWorld.timeStep = 1 / 500
    sceneRenderer.delegate = self
    sceneRenderer.scene = self.scene
    addCubes()
  }
  
  func addCubes() {
    let cubeWidth = CGFloat(0.15)
    let cubeShape = SCNBox(width: cubeWidth, height: cubeWidth, length: cubeWidth, chamferRadius: 0.03)
    
    for i in 0...14 {
      for j in 0...4 {
        for k in 0...4 {
          let cubeNode = SCNNode(geometry: cubeShape)
          cubeNode.position.y = Float(0.2 + 0.21 * Double(k))
          cubeNode.position.x = Float(-1.5 + 0.21 * Double(i))
          cubeNode.position.z = Float(-1.5 + 0.21 * Double(j))
          cubeNode.physicsBody = .dynamic()
          cubeNode.physicsBody?.mass = 5
          cubeNode.physicsBody?.restitution = 0
          cubeNode.physicsBody?.friction = 0.8
          cubeNode.physicsBody?.categoryBitMask = 4
          cubeNode.physicsBody?.collisionBitMask = 7
          scene.rootNode.addChildNode(cubeNode)
        }
      }
    }
  }
  
  func highlightNodes(atPoint point: CGPoint) {
    let hitResults = self.sceneRenderer.hitTest(point, options: [:])
    for result in hitResults {
      //                    highligt(node: result.node)
      if result.node.name == "soundsButton" {
        print("settingsButton pressed")
        return
      } else if result.node.name == "skinsButton" {
        print("skinsButton pressed")
        return
      }
    }
  }
  
  func highligt(node: SCNNode) {
    guard let material = node.geometry?.firstMaterial else {
      return
    }
    
    // highlight it
    SCNTransaction.begin()
    SCNTransaction.animationDuration = 0.5
    
    // on completion - unhighlight
    SCNTransaction.completionBlock = {
      SCNTransaction.begin()
      SCNTransaction.animationDuration = 0.5
      
      material.emission.contents = UIColor.black
      
      SCNTransaction.commit()
    }
    
    material.emission.contents = UIColor.red
    
    SCNTransaction.commit()
  }
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
  }
  
  func touchesMoved(_ from: CGPoint, _ to: CGPoint) {
    
    let dx = (to.x - from.x)
    let dy = (to.y - from.y)
    
    bracket.runAction(.moveBy(x: dx / 35, y: 0, z: dy / 35, duration: 0.2))
    
    let direction = normalize(float2(x: Float(dx), y: Float(dy)))
    
    let angle: CGFloat = CGFloat(atan2(direction.x, direction.y) - .pi)
    
    if angle.isFinite {
      
      bracket.runAction(.rotateTo(x: 0,
                                  y: angle,
                                  z: 0,
                                  duration: 0.05,
                                  usesShortestUnitArc: true))
    }
  }
}

extension GameController: SCNPhysicsContactDelegate {
  
  func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    let firstNode: SCNNode
    let secondNode: SCNNode
    
    guard let firstBitmask = contact.nodeA.physicsBody?.categoryBitMask,
      let secondBitmask = contact.nodeB.physicsBody?.categoryBitMask else {
        return
    }
    
    if firstBitmask < secondBitmask {
      firstNode = contact.nodeA
      secondNode = contact.nodeB
    } else {
      firstNode = contact.nodeB
      secondNode = contact.nodeA
    }
    
    let contactMask = firstBitmask | secondBitmask
    
    switch contactMask {
      
      
    default:
      print("contact that doesn't exists")
    }
  }
}
