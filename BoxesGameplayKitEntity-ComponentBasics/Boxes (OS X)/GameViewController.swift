/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    An `NSViewController` subclass that stores references to game-wide input sources and managers.
*/

import SceneKit

class GameViewController: NSViewController {
    // MARK: Properties
    
    let game = Game()
    
    // MARK: Methods
    
    override func viewDidLoad() {
        // Grab the controller's view as a SceneKit view.
        guard let scnView = view as? SCNView else { fatalError("Unexpected view class") }
        
        // Set our background color to a light gray color.
        scnView.backgroundColor = NSColor.lightGray
        
        // Ensure the view controller can display our game's scene.
        scnView.scene = game.scene
        
        // Ensure the game can manage updates for the scene.
        scnView.delegate = game
    }
    
    override func keyDown(with _: NSEvent) {
        // Causes boxes to jump if a key press is detected.
        game.jumpBoxes()
    }
    
    override func mouseDown(with _: NSEvent) {
        // Causes boxes to jump if a click is detected.
        game.jumpBoxes()
    }
}
