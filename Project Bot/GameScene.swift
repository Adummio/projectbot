//
//  GameScene.swift
//  Project Bot
//
//  Created by Yuri Spaziani on 24/03/2020.
//  Copyright © 2020 Best Devs Evah. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Camera
    var cameraNode = SKCameraNode()
    
    // Player & Movement
    var player : SKSpriteNode?
    let joystick = 🕹(withDiameter: 300)
    
    // Enemies
    var enemies = [SKSpriteNode]()
    var enemy : SKSpriteNode?
    let enemySpeed:CGFloat = 3.0
    
    // Labels
    let resultLabel = SKLabelNode(fontNamed:"Helvetica")

    // Arena
    var arena: SKShapeNode?
    let arenaRadius: CGFloat = 500.0
    var circle = SKShapeNode()
    
    // Animations
    var fallDown = SKAction.scaleX(to: 0, y: 0, duration: 1)
    
    // Others
    let playableRect: CGRect
    var cameraRect: CGRect {
        let x = cameraNode.position.x - size.width/2 + (size.width - playableRect.width)/2
        let y = cameraNode.position.y - size.height/2 + (size.height - playableRect.height)/2
        return CGRect(x:x ,y:y ,width: playableRect.width, height: playableRect.height)
    }
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 9.0/16.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: DIDMOVE
    
    override func didMove(to view: SKView) {
      
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)

        view.isMultipleTouchEnabled = true
        addBackground()
        addResultLabel()
        addJoystick()
        addPlayer(atPosition: CGPoint(x: frame.midX, y: frame.midY))
        addEnemy(atPosition: CGPoint(x: frame.midX, y: frame.midY+150))
        addEnemy(atPosition: CGPoint(x: frame.midX+50, y: frame.midY+250))
        addCircle()
        debugPlayableArea()
        
         joystick.on(.move) { [unowned self] joystick in
                   guard let player = self.player else { return }
                   let pVelocity = joystick.velocity;
                   let speed = CGFloat(0.12)
                   player.position = CGPoint(x: player.position.x + (pVelocity.x * speed), y: player.position.y + (pVelocity.y * speed))
                   player.zRotation = joystick.angular
               }
        
        //        joystick.on(.end) { [unowned self] _ in
        //            let actions = [
        //                SKAction.scale(to: 1.5, duration: 0.5),
        //                SKAction.scale(to: 1, duration: 0.5)
        //            ]
        //
        //            self.mainCharacter?.run(SKAction.sequence(actions))
        //        }
        
    }
    
    func debugPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func addJoystick() {
        // let image = UIImage(named: "")
        joystick.handleImage = nil
        // let substrateImage = UIImage(named: "")
        joystick.baseImage = nil
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        let moveJoystickHiddenArea = AnalogJoystickHiddenArea(rect: CGRect(x: 0 - frame.midX, y: 0 - frame.midY, width: frame.size.width, height: frame.size.height))
        moveJoystickHiddenArea.zPosition = 1
        moveJoystickHiddenArea.joystick = joystick
        joystick.isMoveable = true
        camera!.addChild(moveJoystickHiddenArea)
    }
    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "bg")
        background.zPosition = -1
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    func addResultLabel() {
        resultLabel.isHidden = true
        resultLabel.fontSize = 50
        resultLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        resultLabel.fontColor = UIColor.black
        addChild(resultLabel)
    }
    
    func addPlayer(atPosition position: CGPoint) {
        guard let image = UIImage(named: "mainChar") else { return }
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.position = position
        node.zPosition = 1
        addChild(node)
        player = node
    }
    
    func addEnemy(atPosition position: CGPoint) {
        guard let image = UIImage(named: "enemy") else { return }
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.position = position
        node.zPosition = 1
        addChild(node)
        enemy = node
        enemies.append(enemy!)
        
    }
    
    func addCircle() {
        self.circle = SKShapeNode(circleOfRadius: arenaRadius)
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.fillColor = .yellow
        circle.glowWidth = 1.0
        circle.strokeColor = .black
        circle.zPosition = 0
        addChild(circle)
        arena = circle
    }
    
    func restartScene() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.removeAllActions()
            self.removeAllChildren()
            NotificationCenter.default.post(name: Notification.Name("restartScene"), object: nil)
        }
    }
    
 // MARK: UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        
        let location = player?.position
        camera!.position = player!.position
        
        if circle.contains(location!) {
            player!.isHidden = false
        } else {
            self.resultLabel.isHidden = false
            resultLabel.text = "You Lost"
            enemies.removeAll()
            player?.run(fallDown, completion: {() -> Void in
                self.scene!.view!.isPaused = true
                self.player!.isHidden = true
                self.player?.removeFromParent()
            })
            
            restartScene()
        }
        
        for enemy in enemies {
            //Aim
            let dx = (location?.x)! - enemy.position.x
            let dy = (location?.y)! - enemy.position.y
            let angle = atan2(dy, dx)
            
            enemy.zRotation = angle - 3 * .pi/2
            
            //Seek
            let velocityX = cos(angle) * enemySpeed
            let velocityY = sin(angle) * enemySpeed
            
            enemy.position.x += velocityX
            enemy.position.y += velocityY
            
            if circle.contains(enemy.position) {
                enemy.isHidden = false
            } else {
                self.resultLabel.isHidden = false
                resultLabel.text = "You Won"
                enemy.run(fallDown, completion: {() -> Void in
                    self.scene!.view!.isPaused = true
                    self.enemy!.isHidden = true
                    self.enemy!.removeFromParent()
                })
                
                restartScene()
            }
        }
    }
}
