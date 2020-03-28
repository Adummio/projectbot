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
    var cameraNode = SKCameraNode()
    
    var mainCharacter : SKSpriteNode?
    var enemies = [SKSpriteNode]()
    var enemy : SKSpriteNode?
    let enemySpeed:CGFloat = 3.0
    let joystick = 🕹(withDiameter: 300)
    var arena: SKShapeNode?
    let resultLabel = SKLabelNode(fontNamed:"Chalkduster")

    let arenaRadius: CGFloat = 200.0
    var circle = SKShapeNode()
    
    override func didMove(to view: SKView) {
        
        self.camera = cameraNode
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.zPosition = -1
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        resultLabel.isHidden = true
        resultLabel.fontSize = 20
        resultLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        resultLabel.fontColor = UIColor.black
        addChild(resultLabel)

        //        let image = UIImage(named: "")
        joystick.handleImage = nil
        //        let substrateImage = UIImage(named: "")
        joystick.baseImage = nil
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        let moveJoystickHiddenArea = AnalogJoystickHiddenArea(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.midY/2))
        moveJoystickHiddenArea.zPosition = 1
        moveJoystickHiddenArea.joystick = joystick
        joystick.isMoveable = true
        addChild(moveJoystickHiddenArea)
        
        //        joystick.on(.begin) { [unowned self] _ in
        //            let actions = [
        //                SKAction.scale(to: 0.5, duration: 0.5),
        //                SKAction.scale(to: 1, duration: 0.5)
        //            ]
        //
        //            self.mainCharacter?.run(SKAction.sequence(actions))
        //        }
        
        joystick.on(.move) { [unowned self] joystick in
            guard let mainCharacter = self.mainCharacter else {
                return
            }
            
            let pVelocity = joystick.velocity;
            let speed = CGFloat(0.12)
            
            mainCharacter.position = CGPoint(x: mainCharacter.position.x + (pVelocity.x * speed), y: mainCharacter.position.y + (pVelocity.y * speed))
            
            mainCharacter.zRotation = joystick.angular
        }
        
        //        joystick.on(.end) { [unowned self] _ in
        //            let actions = [
        //                SKAction.scale(to: 1.5, duration: 0.5),
        //                SKAction.scale(to: 1, duration: 0.5)
        //            ]
        //
        //            self.mainCharacter?.run(SKAction.sequence(actions))
        //        }
        
        addMainCharacter(atPosition: CGPoint(x: frame.midX, y: frame.midY))
        addEnemy(atPosition: CGPoint(x: frame.midX, y: frame.midY+150))
        addCircle()
        
        view.isMultipleTouchEnabled = true
    }
    
    
    func addMainCharacter(atPosition position: CGPoint) {
        guard let image = UIImage(named: "mainChar") else {
            return
        }
        
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.position = position
        node.zPosition = 1
        addChild(node)
        mainCharacter = node
    }
    
    func addEnemy(atPosition position: CGPoint) {
        guard let image = UIImage(named: "enemy") else {
            return
        }
        
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
    
    func addCircle(){
        self.circle = SKShapeNode(circleOfRadius: arenaRadius)
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.fillColor = .yellow
        circle.glowWidth = 1.0
        circle.strokeColor = .black
        circle.zPosition = 0
        addChild(circle)
        arena = circle
    }
    
    //    func addCircleObstacle() {
    //      // 1
    //      let path = UIBezierPath()
    //      // 2
    //      path.move(to: CGPoint(x: 0, y: -200))
    //      // 3
    //      path.addLine(to: CGPoint(x: 0, y: -160))
    //      // 4
    //      path.addArc(withCenter: CGPoint.zero,
    //                  radius: 160,
    //                  startAngle: CGFloat(3.0 * Double.pi/2),
    //                  endAngle: CGFloat(0),
    //                  clockwise: true)
    //      // 5
    //      path.addLine(to: CGPoint(x: 200, y: 0))
    //      path.addArc(withCenter: CGPoint.zero,
    //                  radius: 200,
    //                  startAngle: CGFloat(0.0),
    //                  endAngle: CGFloat(3.0 * Double.pi/2),
    //                  clockwise: false)
    //
    //
    //        let section = SKShapeNode(path: path.cgPath)
    //        section.position = CGPoint(x: size.width/2, y: size.height/2)
    //        section.fillColor = .yellow
    //        section.strokeColor = .yellow
    //        addChild(section)
    //    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
    }
    
 
    override func update(_ currentTime: TimeInterval) {
        
        
        let location = mainCharacter?.position
        
        cameraNode.position = mainCharacter!.position
        
        if circle.contains(location!) {
            mainCharacter!.isHidden = false
        } else {
            self.resultLabel.isHidden = false
            resultLabel.text = "Porco dio you lost !"
            mainCharacter!.isHidden = true
            mainCharacter?.removeFromParent()
        }
        //        let arenaLocation = arena?.position
        //
        //        let xDist = (location?.x ?? 0) - (arenaLocation?.x ?? 0)
        //        let yDist = (location?.y ?? 0) - (arenaLocation?.y ?? 0)
        //        let distance = sqrt(xDist*xDist + yDist*yDist)
        //
        //        if distance < arenaRadius{
        //            print("die")
        //        }
        
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
                resultLabel.text = "Porco dio you won !"
                enemy.isHidden = true
                enemy.removeFromParent()
            }
        }
    }
}
