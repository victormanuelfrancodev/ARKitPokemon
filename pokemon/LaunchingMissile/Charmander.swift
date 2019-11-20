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

class Charmander : SCNNode {
    
    
    private var scene :SCNScene!
    
    init(scene :SCNScene) {
        super.init()
        
        self.scene = scene
        
        setup()
    }
    
    init(charmanderNode :SCNNode) {
        super.init()
        
        // self.missileNode = missileNode
        
        setup()
    }
    
    private func setup() {
        
        guard let charmanderNode = self.scene.rootNode.childNode(withName: "Charmander", recursively: true),
            let fireNode = self.scene.rootNode.childNode(withName: "EndTailA03", recursively: true)
            else {
                fatalError("Node not found!")
        }
        
        let fireNodeParticle = SCNParticleSystem(named: "art.scnassets/Fire.scnp", inDirectory: nil)
        //fireNode?.emitterShape = self.geometry
        fireNodeParticle?.particleSize = 0.02
      //  fireNode?.emitterShape = SCNBox(width: 0.002, height: 0.002, length: 0.0002, chamferRadius: 0)
        fireNode.addParticleSystem(fireNodeParticle!)
        fireNode.position = SCNVector3(0, 0.02, 0.98)
    
        
        
        self.addChildNode(charmanderNode)
        self.addChildNode(fireNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

