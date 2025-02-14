//
//  GameScene.swift
//  MAXWELLTHING
//
//  Created by MATTHEW FITCH on 2/13/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var onJoystick = false
    
    var origin: CGPoint!
    
    var touchPos: CGPoint?
     
    var ball: SKSpriteNode!
    
    var joystick: SKSpriteNode!
    
    var joystickBack: SKSpriteNode!
    
    let cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        
        joystickBack = SKSpriteNode(color: .gray, size: CGSize(width: 100, height: 100))
        joystickBack.alpha = 0.5
        joystickBack.zPosition = 10
        
        // Create the joystick knob
        joystick = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
        joystick.zPosition = 11
        
        
        let joystickPosition = CGPoint(x: -460.187, y: -195.792)
        
        joystick.position = joystickPosition
        joystickBack.position = joystickPosition
        
        // **Add the camera to the scene**
        self.camera = cam
        self.addChild(cam)

        origin = joystick.position

        // **Reparent the joystick to the camera**
        cam.addChild(joystick)
        cam.addChild(joystickBack)
    }

    
    
    func touchDown(atPoint pos : CGPoint) {
        if cam.convert(pos, from: self).x > 0
        {
            return
        }
        touchPos = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if cam.convert(pos, from: self).x > 0
        {
            return
        }
        touchPos = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if cam.convert(pos, from: self).x > 0
        {
            return
        }
        joystick.position = origin
        ball.physicsBody?.velocity.dx = 0
        onJoystick = false
        touchPos = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        cam.position.x = ball.position.x
        
        if touchPos == nil
        {
            return
        }
        
        touchPos = cam.convert(touchPos!, from: self)
        
        if joystick.contains(touchPos!) || onJoystick {
            onJoystick = true
            print("Joystick parent: \(joystick.parent?.name ?? "None")")
            joystick.position = touchPos!
            
            var amountToMove = (touchPos!.x - origin.x) * 5
            
            ball.physicsBody?.velocity.dx = amountToMove
        } else {
//            print("Point is outside the sprite.")
        }
    }
}
