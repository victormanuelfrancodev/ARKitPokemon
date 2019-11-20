//
//  ViewController.swift
//  MultipleArKit
//
//  Created by Victor Manuel Lagunas Franco on 19/11/19.
//  Copyright © 2019 Victor Manuel Lagunas Franco. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        let cube = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)
        
        let materialBox = SCNMaterial()
        //materialBox.diffuse.contents = UIColor.blue
        materialBox.name = "Color"
        materialBox.diffuse.contents = UIImage(named: "wood")
        let nodeCube = SCNNode(geometry: cube)
        nodeCube.position = SCNVector3(0.0, 0.0, -0.5)
        nodeCube.geometry?.materials = [materialBox]
        
        let sphere = SCNSphere(radius: 0.3)
        //sphere.firstMaterial?.diffuse.contents = UIColor.green
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth")
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0.5, 0.0, -0.5)
        
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        self.sceneView.scene.rootNode.addChildNode(nodeCube)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer:UIGestureRecognizer){
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty{
            let node = hitResults[0].node
            let material = node.geometry?.material(named: "Color")
            material?.diffuse.contents = UIColor.random()
        }
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
