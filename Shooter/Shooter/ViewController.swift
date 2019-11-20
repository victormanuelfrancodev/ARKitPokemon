//
//  ViewController.swift
//  Shooter
//
//  Created by Victor Manuel Lagunas Franco on 20/11/19.
//  Copyright © 2019 Victor Manuel Lagunas Franco. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


enum BoxBodyType:Int{
    case bullet = 1
    case barrier = 2
}

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var lastContactNode:SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        let box1 = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        box1.materials = [material]
        
        let box2 = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.red
        box2.materials = [material2]
        
        let box3 = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIColor.yellow
        box3.materials = [material3]
        // Set the scene to the view
        
        let nodo1 = SCNNode(geometry: box1)
        nodo1.position = SCNVector3(0.0,0,-0.8)
        nodo1.name = "Barrier1"
        nodo1.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        nodo1.physicsBody?.categoryBitMask = BoxBodyType.barrier.rawValue
        
        let nodo2 = SCNNode(geometry: box2)
        nodo2.position = SCNVector3(-0.2,0,-0.8)
        nodo2.name = "Barrier2"
        nodo2.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        nodo2.physicsBody?.categoryBitMask = BoxBodyType.barrier.rawValue
        //nodo2.physicsBody?.categoryBitMask = BoxBodyType.barrier.rawValue
        
        let nodo3 = SCNNode(geometry: box3)
        nodo3.position = SCNVector3(0.2,0.2,-0.8)
        nodo3.name = "Barrier3"
        nodo3.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        nodo3.physicsBody?.categoryBitMask = BoxBodyType.barrier.rawValue
        
        scene.rootNode.addChildNode(nodo1)
        scene.rootNode.addChildNode(nodo2)
        scene.rootNode.addChildNode(nodo3)
        
        sceneView.scene = scene
        
        self.sceneView.scene.physicsWorld.contactDelegate = self
        
        registerGestureRecognizers()
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "Bullet"{
            contactNode = contact.nodeB
        }else{
            contactNode = contact.nodeA
        }
        
        if self.lastContactNode != nil && self.lastContactNode == contactNode {
            return
        }
        
        self.lastContactNode = contactNode
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        
        self.lastContactNode.geometry?.materials = [material]
        
        
    }
    
    private func registerGestureRecognizers(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shoot))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func shoot(recognizer: UIGestureRecognizer){
        guard let currentFrame = self.sceneView.session.currentFrame else{
            return
        }
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.3
        
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "Bullet"
        
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.categoryBitMask = BoxBodyType.bullet.rawValue
        boxNode.physicsBody?.contactTestBitMask = BoxBodyType.barrier.rawValue
        boxNode.physicsBody?.isAffectedByGravity = false
        
        boxNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
        let forceVector = SCNVector3(boxNode.worldFront.x * 2, boxNode.worldFront.y * 2, boxNode.worldFront.z * 2)
        boxNode.physicsBody?.applyForce(forceVector, asImpulse: true)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
