//
//  GameScene.swift
//  MAXWELLTHING
//
//  Created by MATTHEW FITCH on 2/13/25.
//

import SpriteKit
import GameplayKit

class GameScene2: SKScene, SKPhysicsContactDelegate {
    
    var onJoystick = false
    
    var jumpDown = false
    
    var diePlease = false
    
    var lastCheckpoint = CGPoint(x: -135, y: 155)
    
    var curHook: SKShapeNode?
    
    var onGround = false
    
    var origin: CGPoint!
    
    var touchLastFrame = CGPoint(x: 0, y: 0)
    
    var touchPos: CGPoint?
    
    var amountToMove = 0.0
     
    var ball: SKSpriteNode!
    
    var joystick: SKSpriteNode!
    
    var joystickBack: SKSpriteNode!
    
    var grapplingThings = [SKNode]()
    
    var jumpPads = [SKNode]()
    
    let cam = SKCameraNode()
    
    var currentGrapple: SKNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        
        grapplingThings.append(self.childNode(withName: "grapple-collider1") as! SKNode)
        grapplingThings.append(self.childNode(withName: "grapple-collider2") as! SKNode)
        grapplingThings.append(self.childNode(withName: "grapple-collider3") as! SKNode)
        
        
        jumpPads.append(self.childNode(withName: "jump-pad1") as! SKNode)
        jumpPads.append(self.childNode(withName: "jump-pad2") as! SKNode)
        jumpPads.append(self.childNode(withName: "jump-pad3") as! SKNode)
        joystickBack = SKSpriteNode(color: .gray, size: CGSize(width: 200, height: 200))
        joystickBack.alpha = 0.5
        joystickBack.zPosition = 10
        
        // create joystick knob
        joystick = SKSpriteNode(color: .white, size: CGSize(width: 175, height: 175))
        joystick.zPosition = 11
        
        
        let joystickPosition = CGPoint(x: -430, y: -185)
        
        joystick.position = joystickPosition
        joystickBack.position = joystickPosition
        
        // **Add the camera to the scene**
        self.camera = cam
        self.addChild(cam)

        origin = joystick.position

        // **Reparent the joystick to the camera**
        cam.addChild(joystick)
        cam.addChild(joystickBack)
        
        for grapplingThing in grapplingThings {
            let collisionBody = SKPhysicsBody(circleOfRadius: 500)// or use other shapes
            collisionBody.isDynamic = false  // It won't move
            collisionBody.categoryBitMask = 0
            collisionBody.contactTestBitMask = 1
            collisionBody.collisionBitMask = 0
            
            grapplingThing.physicsBody = collisionBody
            
            let indicator = SKSpriteNode(color: .green, size: CGSize(width: 10, height: 10))
            
            grapplingThing.addChild(indicator)
        }
        
        for jumpPad in jumpPads {
            let collisionBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 30))// or use other shapes
            collisionBody.isDynamic = false  // It won't move
            collisionBody.categoryBitMask = 0
            collisionBody.contactTestBitMask = 1
            collisionBody.collisionBitMask = 0
            
            jumpPad.zPosition = 20
            
            jumpPad.physicsBody = collisionBody
            
            let indicator = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 30))
            
            jumpPad.addChild(indicator)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" {
            onGround = true
        } else if contact.bodyA.node?.name == "danger" || contact.bodyB.node?.name == "danger" {
            diePlease = true
        } else {
//            dropping last character for "general" nodes that have multiple copies
            var nameA = contact.bodyA.node!.name!
            
            nameA = String(nameA.dropLast())
            
            var nameB = contact.bodyB.node!.name!
            
            nameB = String(nameB.dropLast())
            
            if nameA == "jump-pad" || nameB == "jump-pad" {
                let jumpPad = (nameA == "jump-pad") ? contact.bodyA.node! : contact.bodyB.node!
                ball.physicsBody?.velocity = CGVector(dx: sin(Double(jumpPad.zRotation)) * -1200, dy: cos(Double(jumpPad.zRotation)) * 1200)
                return
            }
            
            if (nameA == "grapple-collider" && nameB == "bal") || (nameB == "grapple-collider" && nameA == "bal")  {
                print("BIG WEE WOOOOOOO")
                currentGrapple = (nameA == "grapple-collider") ? contact.bodyA.node! : contact.bodyB.node!
                return
            }
            
            if nameA == "en" || nameB == "en" {
                let nextLevel = GameScene2(fileNamed: "GameScene2")!
                nextLevel.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view!.presentScene(nextLevel, transition: transition)
            }
            
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" {
            onGround = false
        } else {
//            dropping last character for "general" nodes that have multiple copies
            var nameA = contact.bodyA.node!.name!
            
            nameA = String(nameA.dropLast())
            
            var nameB = contact.bodyB.node!.name!
            
            nameB = String(nameB.dropLast())
            
            if (nameA == "grapple-collider" && nameB == "bal") || (nameB == "grapple-collider" && nameA == "bal") {
                currentGrapple = nil
                return
            }
        }
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
        print(cam.convert(pos, from: self).x)
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
        if diePlease {
            diePlease = false
            die()
        }
        cam.position.x = ball.position.x
        cam.position.y = ball.position.y
        
        // joystick garbage
        if touchPos != nil
        {
            var newTouchPos = cam.convert(touchPos!, from: self)
            
            if touchLastFrame.x == touchPos!.x && touchLastFrame.y == touchPos!.y
            {
                if onJoystick {
                    ball.physicsBody?.velocity.dx = amountToMove
                } else if joystick.contains(newTouchPos) {
                    onJoystick = true
                    //            print("position: \(touchPos)")
                    joystick.position = newTouchPos
                    
                    amountToMove = (newTouchPos.x - origin.x) * 5
                    
                    ball.physicsBody?.velocity.dx = amountToMove
                }
            } else {
                if joystick.contains(newTouchPos) {
                    onJoystick = true
                    //            print("position: \(touchPos)")
                    joystick.position = newTouchPos
                    
                    amountToMove = (newTouchPos.x - origin.x) * 5
                    
                    ball.physicsBody?.velocity.dx = amountToMove
                } else if onJoystick {
                    ball.physicsBody?.velocity.dx = amountToMove
                }
            }
            
            touchLastFrame = touchPos!
            
        }
        // move enemies
//        for enemy in enemies {
//            if enemy.position.x < ball.position.x {
//                enemy.physicsBody?.velocity.dx = 100
//            } else {
//                enemy.physicsBody?.velocity.dx = -100
//            }
//        }
        
//        remove current line if any
        if curHook != nil {
            curHook!.removeFromParent()
        }
        
        // update grappling hook
        if jumpDown && currentGrapple != nil {
            ball.physicsBody?.velocity.dx += (currentGrapple!.position.x - ball.position.x)
            ball.physicsBody?.velocity.dy += (currentGrapple!.position.y - ball.position.y) / 2 - 30
            
            print(ball.physicsBody?.velocity)
            
            
            
            
//            update the line thing
            
            let line = SKShapeNode()
                
//            create path for the line
            let path = CGMutablePath()
            path.move(to: ball.position)
            path.addLine(to: currentGrapple!.position)
            
//            set path for line
            line.path = path
            line.strokeColor = .white  // Set your desired color
            line.lineWidth = 5       // Set line width
            curHook = line
            
            self.addChild(line)
            
        }
        
        if ball.position.y < -400 {
            die()
        }
    }
    
    let deathMessages = ["ouch...", "you died lol", "nice one"]
    
    func die()
    {
        var deathMessage = SKLabelNode(text: deathMessages[Int.random(in: 0..<deathMessages.count)])
        
        deathMessage.position = CGPoint(x: 0, y: 100)
        
        deathMessage.fontSize = 50
        
        deathMessage.zPosition = 20
        
        deathMessage.fontColor = .red
        
        cam.addChild(deathMessage)
        
        let fadeOutAction = SKAction.fadeAlpha(to: 0.0, duration: 2.5)
        
        fadeOutAction.timingMode = .easeOut
        
        deathMessage.run(fadeOutAction)
        
        ball.position.x = lastCheckpoint.x
        ball.position.y = lastCheckpoint.y
        
        print(lastCheckpoint)
    }
    
    
}
