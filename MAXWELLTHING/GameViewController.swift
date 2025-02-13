//
//  GameViewController.swift
//  MAXWELLTHING
//
//  Created by MATTHEW FITCH on 2/13/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var play: GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                play = scene as? GameScene
                // Present the scene
                view.presentScene(scene)
            }
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func jumpAction(_ sender: Any) {
        play.ball.physicsBody?.velocity.dy = 800
    }
}
