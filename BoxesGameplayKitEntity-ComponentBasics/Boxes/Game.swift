/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Handles logic controlling the scene. Primarily, it initializes the game's entities and components structure, and handles game updates.
*/

import SceneKit
import GameplayKit

class Game: NSObject, SCNSceneRendererDelegate {
    // MARK: Properties
    
    /// The scene that the game controls.
    let scene = SCNScene(named: "GameScene.scn")!
    
    /**
        Manages all of the player control components, allowing you to access all 
        of them in one place.
    */
    let playerControlComponentSystem = GKComponentSystem(componentClass: PlayerControlComponent.self)
    
    /**
        Manages all of the particle components, allowing you to update all of 
        them synchronously.
    */
    let particleComponentSystem = GKComponentSystem(componentClass: ParticleComponent.self)
    
    /// Holds the box entities, so they won't be deallocated.
    var boxEntities = [GKEntity]()
    
    /// Keeps track of the time for use in the update method.
    var previousUpdateTime: TimeInterval = 0
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        setUpEntities()
        addComponentsToComponentSystems()
    }
    
    /**
        Sets up the entities for the scene. It creates four entities with a
        factory method, but leaves the purple box entity for you to set up 
        yourself.
    */
    func setUpEntities() {
        // Create entities with components using the factory method.
        let redBoxEntity = makeBoxEntity(forNodeWithName: "redBox")
        
        let yellowBoxEntity = makeBoxEntity(forNodeWithName: "yellowBox", withParticleComponentNamed: "Fire")
        
        let greenBoxEntity = makeBoxEntity(forNodeWithName: "greenBox", wantsPlayerControlComponent: true)
        
        let blueBoxEntity = makeBoxEntity(forNodeWithName: "blueBox", wantsPlayerControlComponent: true, withParticleComponentNamed: "Sparkle")

        // Create the box entity and grab its node from the scene.
        let purpleBoxEntity = GKEntity()
        let purpleBoxNode = scene.rootNode.childNode(withName: "purpleBox", recursively: false)
        
        // Create the purple box's geometry component, and add it to the entity.
        let geometryComponent = GeometryComponent(geometryNode: purpleBoxNode!)
        purpleBoxEntity.addComponent(geometryComponent)
        
        /* 
            Experiment for yourself:
            Try creating and attaching a ParticleComponent and 
            PlayerControlComponent for the purple box in the space below.
        */
        
        // Keep track of all the newly-created box entities.
        boxEntities = [
            redBoxEntity,
            yellowBoxEntity,
            greenBoxEntity,
            blueBoxEntity,
            purpleBoxEntity
        ]
    }
    
    /**
        Checks each box for components. If a box has a particle and/or player 
        control component, it is added to the appropriate component system.
        Since the methods `jumpBoxes(_:)` and `renderer(_:)` use component
        systems to reference components, a component will not properly affect 
        the scene unless it is added to one of these systems.
    */
    func addComponentsToComponentSystems() {
        for box in boxEntities {
            particleComponentSystem.addComponent(foundIn: box)
            playerControlComponentSystem.addComponent(foundIn: box)
        }
    }
    
    // MARK: Methods
    
    /**
        Causes each box controlled by an entity with a playerControlComponent 
        to jump.
    */
    func jumpBoxes() {
        /*
            Iterate over each component in the component system that is a
            PlayerControlComponent.
        */
        for case let component as PlayerControlComponent in playerControlComponentSystem.components {
            component.jump()
        }
    }
    
    /**
        Updates every frame, and keeps components in the particle component 
        system up to date.
    */
    func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Calculate the time change since the previous update.
        let timeSincePreviousUpdate = time - previousUpdateTime
        
        // Update the particle component system with the time change.
        particleComponentSystem.update(deltaTime: timeSincePreviousUpdate)
        
        // Update the previous update time to keep future calculations accurate.
        previousUpdateTime = time
    }
    
    // MARK: Box Factory Method
    
    /**
        Creates box entities with a set of components as specified in the 
        parameters. It uses default parameter values so parameters can be 
        ommitted in the method call. The parameter particleComponentName is a 
        string optional so its default parameter value can be nil.
    
        - Parameter name: The name of the box that this entity should manage.
    
        - Parameter wantsPlayerControlComponent: Whether or not this entity 
        should be set up with a player control component.
    
        - Parameter particleComponentName: The name of the particle
        component entity should be set up with.
    
        - Returns: An entity with the set of components requested.
    */
    func makeBoxEntity(forNodeWithName name: String, wantsPlayerControlComponent: Bool = false, withParticleComponentNamed particleComponentName: String? = nil) -> GKEntity {
        // Create the box entity and grab its node from the scene.
        let box = GKEntity()
        guard let boxNode = scene.rootNode.childNode(withName: name, recursively: false) else {
            fatalError("Making box with name \(name) failed because the GameScene scene file contains no nodes with that name.")
        }
        
        // Create and attach a geometry component to the box.
        let geometryComponent = GeometryComponent(geometryNode: boxNode)
        box.addComponent(geometryComponent)
        
        // If requested, create and attach a particle component.
        if let particleComponentName = particleComponentName {
            let particleComponent = ParticleComponent(particleName: particleComponentName)
            box.addComponent(particleComponent)
        }
        
        // If requested, create and attach a player control component.
        if wantsPlayerControlComponent {
            let playerControlComponent = PlayerControlComponent()
            box.addComponent(playerControlComponent)
        }
        
        return box
    }
}
