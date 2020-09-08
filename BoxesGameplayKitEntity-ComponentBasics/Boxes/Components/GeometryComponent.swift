/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A component that attaches to an entity. This component controls a geometry node's physics body.
*/

import SceneKit
import GameplayKit

class GeometryComponent: GKComponent {
    // MARK: Properties
    
    /// A reference to the box in the scene that the entity controls.
    let geometryNode: SCNNode
    
    // MARK: Initialization
    
    init(geometryNode: SCNNode) {
        self.geometryNode = geometryNode
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    /// Applies an upward impulse to the entity's box node, causing it to jump.
    func applyImpulse(_ vector: SCNVector3) {
        geometryNode.physicsBody?.applyForce(vector, asImpulse: true)
    }
}
