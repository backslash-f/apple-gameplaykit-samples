/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A `UIViewController` subclass that stores references to game-wide input sources and managers.
*/

import UIKit
import SceneKit

class GameViewController: UIViewController {
    // MARK: Properties
    
    let game = Game()
    
    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grab the controller's view as a SceneKit view.
        guard let scnView = view as? SCNView else { fatalError("Unexpected view class") }
        
        // Set our background color to a light gray color.
        scnView.backgroundColor = UIColor.lightGray
        
        // Ensure the view controller can display our game's scene.
        scnView.scene = game.scene
        
        // Ensure the game can manage updates for the scene.
        scnView.delegate = game
    }
    
    /// Causes the boxes to jump if a tap is detected.
    @IBAction func handleTap(_: UITapGestureRecognizer) {
        game.jumpBoxes()
    }
}
