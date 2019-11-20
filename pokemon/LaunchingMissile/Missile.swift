//
//  Missile.swift
//  Hello-AR
//
//  Created by Mohammad Azam on 7/1/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Missile : SCNNode {
    
    
    private var scene :SCNScene!
    
    init(scene :SCNScene) {
        super.init()
        
        self.scene = scene
        
        setup()
    }
    
    init(missileNode :SCNNode) {
        super.init()
        
        // self.missileNode = missileNode
        
        setup()
    }
    
    private func setup() {
        
        guard let missileNode = self.scene.rootNode.childNode(withName: "Charmander", recursively: true),
            let smokeNode = self.scene.rootNode.childNode(withName: "EndTailA03", recursively: true)
            else {
                fatalError("Node not found!")
        }
        
        let smoke = SCNParticleSystem(named: "art.scnassets/Fire.scnp", inDirectory: nil)
        //smoke?.emitterShape = self.geometry
        smoke?.particleSize = 0.02
      //  smoke?.emitterShape = SCNBox(width: 0.002, height: 0.002, length: 0.0002, chamferRadius: 0)
        smokeNode.addParticleSystem(smoke!)
        smokeNode.position = SCNVector3(0, 0.02, 0.98)
    
        
        
        self.addChildNode(missileNode)
        self.addChildNode(smokeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

