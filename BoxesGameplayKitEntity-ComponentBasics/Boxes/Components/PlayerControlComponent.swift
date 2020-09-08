/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A component that attaches to an entity. This component enables a geometry node to jump.
*/

import GameplayKit
import SceneKit

class PlayerControlComponent: GKComponent {
    // MARK: Properties

    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    // MARK: Methods
    
    /// Tells this entity's geometry component to jump.
    func jump() {
        let jumpVector = SCNVector3(x: 0, y: 2, z: 0)
        geometryComponent?.applyImpulse(jumpVector)
    }
}
