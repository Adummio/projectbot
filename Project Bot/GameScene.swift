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
    
    var mainCharacter : SKSpriteNode?
    var enemies = [SKSpriteNode]()
    var enemy : SKSpriteNode?
    let joystick = 🕹(withDiameter: 100)
    var arena: SKShapeNode?
    let arenaRadius: CGFloat = 200.0
    
    let enemySpeed:CGFloat = 3.0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.zPosition = -1
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
       
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
        addEnemy(atPosition: CGPoint(x: frame.midX, y: frame.maxY-100))
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
        let circle = SKShapeNode(circleOfRadius: arenaRadius)
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
//        if touches.count == 2{
//            let actions = [
//                let vector = CGVector(
//                SKAction.move(by: <#T##CGVector#>, duration: <#T##TimeInterval#>)
//            ]
//        }
    }

//    var entities = [GKEntity]()
//    var graphs = [String : GKGraph]()
//
//    private var lastUpdateTime : TimeInterval = 0
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//
//    override func sceneDidLoad() {
//
//        self.lastUpdateTime = 0
//
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//
//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//
    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//
//        // Initialize _lastUpdateTime if it has not already been
//        if (self.lastUpdateTime == 0) {
//            self.lastUpdateTime = currentTime
//        }
//
//        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
//
//        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }
//
//        self.lastUpdateTime = currentTime
        

        let location = mainCharacter?.position
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
         }
        
    }
}
