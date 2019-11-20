//
//  ViewController.swift
//  Hello-AR
//
//  Created by Mohammad Azam on 6/18/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
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
        let pokemonScene = SCNScene(named: "art.scnassets/Charmander.scn")
        
        let charmander = Charmander(scene: pokemonScene!)
        charmander.name = "Charmander"
        charmander.position = SCNVector3(0,0,-1)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(charmander)
        
        sceneView.scene = scene
        
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        guard let charmanderNode = self.sceneView.scene.rootNode.childNode(withName: "Charmander", recursively: true)
                   else {
                       fatalError("Charmander not found")
               }
        charmanderNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        charmanderNode.physicsBody?.isAffectedByGravity = false
        charmanderNode.physicsBody?.damping = 0.0
        
        charmanderNode.physicsBody?.applyForce(SCNVector3(0,100,0), asImpulse: false)
  
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
    
    
}



