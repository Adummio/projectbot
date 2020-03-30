//
//  GameScene.swift
//  Project Bot
//
//  Created by Yuri Spaziani on 24/03/2020.
//  Copyright © 2020 Best Devs Evah. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Camera
    var cameraNode = SKCameraNode()
    
    // Players & Movement
    var isDead = false
    var player1 : SKSpriteNode?
    var player2 : Player?
    var player3 : Player?
    var player4 : Player?
    let joystick = 🕹(withDiameter: 300)
    
    class Player: SKSpriteNode{
        var playerSpeed: CGFloat = 3.0
    }

    var alivePlayers = [Player]()
    
    // Upgrades & Downgrades
    var power : SKSpriteNode?
    
    // Labels
    let resultLabel = SKLabelNode(fontNamed:"Helvetica")

    // Arena
    var arena: SKShapeNode?
    let arenaRadius: CGFloat = 700.0
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
    
    // MARK: PHYSICS CATEGORIES
    
    enum PhysicsCategories: UInt32 {
        case player1 = 0b00000001 // 1
        case player2 = 0b00000010 // 2
        case player3 = 0b00000100 // 4
        case player4 = 0b00001000 // 8
        case powers = 0b00010000 // 4
        case arena = 0b00100000 // 8
    }
    
    // MARK: DIDMOVE
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)

        view.isMultipleTouchEnabled = true
        addBackground()
        addResultLabel()
        addJoystick()
        addPlayer1(atPosition: CGPoint(x: frame.midX-400, y: frame.midY-400))
        addPlayer2(atPosition: CGPoint(x: frame.midX-400, y: frame.midY+400))
        addPlayer3(atPosition: CGPoint(x: frame.midX+400, y: frame.midY+400))
        addPlayer4(atPosition: CGPoint(x: frame.midX+400, y: frame.midY-400))
        addCircle()
        randomPowerSpawn()
//        debugPlayableArea()
        
        
        
        
         joystick.on(.move) { [unowned self] joystick in
            guard let player = self.player1 else { return }
                   let pVelocity = joystick.velocity;
            let speed = self.isDead ? 0.0 : CGFloat(0.12)
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
    
    
    func addPlayer1(atPosition position: CGPoint) {
        guard let image = UIImage(named: "mainChar") else { return }
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody?.mass = 0.5
        node.physicsBody?.categoryBitMask = PhysicsCategories.player1.rawValue
        node.physicsBody?.collisionBitMask = 00001111
        node.physicsBody?.contactTestBitMask = 00001111
        node.position = position
        node.zPosition = 1
        addChild(node)
//        alivePlayers?.append(player)
        player1 = node
    }
    
    func addPlayer2(atPosition position: CGPoint) {
        guard let image = UIImage(named: "enemy") else { return }
        let texture = SKTexture(image: image)
        let node = Player(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody?.mass = 0.5
        node.physicsBody?.categoryBitMask = PhysicsCategories.player2.rawValue
        node.physicsBody?.collisionBitMask = 00001111
        node.physicsBody?.contactTestBitMask = 00001111
        node.position = position
        node.zPosition = 1
        addChild(node)
        player2 = node
        alivePlayers.append(node)
    }
    
    func addPlayer3(atPosition position: CGPoint) {
        guard let image = UIImage(named: "enemy") else { return }
        let texture = SKTexture(image: image)
        let node = Player(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody?.mass = 0.5
        node.physicsBody?.categoryBitMask = PhysicsCategories.player3.rawValue
        node.physicsBody?.collisionBitMask = 00001111
        node.physicsBody?.contactTestBitMask = 00001111
        node.position = position
        node.zPosition = 1
        addChild(node)
        player3 = node
        alivePlayers.append(node)
    }
    
    func addPlayer4(atPosition position: CGPoint) {
        guard let image = UIImage(named: "enemy") else { return }
        let texture = SKTexture(image: image)
        let node = Player(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody?.mass = 0.5
        node.physicsBody?.categoryBitMask = PhysicsCategories.player4.rawValue
        node.physicsBody?.collisionBitMask = 00001111
        node.physicsBody?.contactTestBitMask = 00001111
        node.position = position
        node.zPosition = 1
        addChild(node)
        player4 = node
        alivePlayers.append(node)
    }
    
    func addCircle() {
        self.circle = SKShapeNode(circleOfRadius: arenaRadius)
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.fillColor = .lightGray
        circle.glowWidth = 1.0
        circle.strokeColor = .black
        circle.zPosition = 0
        addChild(circle)
        arena = circle
    }
    
    func addBigger(atPosition position: CGPoint) {
        guard let image = UIImage(named: "bigger") else { return }
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategories.powers.rawValue
        node.physicsBody?.collisionBitMask = 00001111
        node.physicsBody?.contactTestBitMask = 00001111
        node.position = position
        node.zPosition = 1
        addChild(node)
        power = node
    }
    
     func collideBigger(player: SKSpriteNode) {
            player.physicsBody?.mass = 5
            let scale = SKAction.scale(to: CGSize(width: 200, height: 200), duration: 0.5)
            let wait = SKAction.wait(forDuration: 5)
            let seq = SKAction.sequence([scale,wait])
            player.run(seq, completion: {() -> Void in
                player.physicsBody?.mass = 0.5
                player.run(SKAction.scale(to: CGSize(width: 64, height: 64), duration: 0.5))
            })
        }
    
    func randomPowerSpawn() {
        let minX = frame.midX - 300
        let maxX = frame.midX + 300
        let minY = frame.midY - 300
        let maxY = frame.midY + 300
        let wait = SKAction.wait(forDuration: 10, withRange: 15)
        let spawn = SKAction.run {
            self.power?.removeFromParent()
            self.addBigger(atPosition: CGPoint(x: CGFloat.random(in: minX..<maxX), y: CGFloat.random(in: minY..<maxY)))
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func restartScene() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.removeAllActions()
            self.removeAllChildren()
            NotificationCenter.default.post(name: Notification.Name("restartScene"), object: nil)
        }
    }
    
    func followPlayer(location: CGPoint, enemy: Player, index: Int) {
        let dx = (location.x) - enemy.position.x
        let dy = (location.y) - enemy.position.y
            let angle = atan2(dy, dx)
                    
        enemy.zRotation = angle - 3 * .pi/2
                    
        //Seek
        let velocityX = cos(angle) * enemy.playerSpeed
        let velocityY = sin(angle) * enemy.playerSpeed
                    
        enemy.position.x += velocityX
        enemy.position.y += velocityY
                    
        if circle.contains(enemy.position) {
            enemy.isHidden = false
        } else {
            enemy.playerSpeed = 0
            enemy.run(fallDown, completion: {() -> Void in
                enemy.isHidden = true
                enemy.removeFromParent()
                self.alivePlayers.remove(at: index)
                if self.alivePlayers.isEmpty{
                    self.resultLabel.text = "You Won"
                    self.resultLabel.isHidden = false
                    self.scene!.view!.isPaused = true
                }
            })
                        
        //   restartScene()
            }
    }
    
  // MARK: DIDBEGIN COLLIDE
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        // Player collides Powers
        
        switch collision{
        case PhysicsCategories.player1.rawValue | PhysicsCategories.powers.rawValue:
            collideBigger(player: player1!)
            power?.removeFromParent()
        case PhysicsCategories.player2.rawValue | PhysicsCategories.powers.rawValue:
            collideBigger(player: player2!)
            power?.removeFromParent()
        case PhysicsCategories.player3.rawValue | PhysicsCategories.powers.rawValue:
            collideBigger(player: player3!)
            power?.removeFromParent()
        case PhysicsCategories.player4.rawValue | PhysicsCategories.powers.rawValue:
            collideBigger(player: player4!)
            power?.removeFromParent()
        default:
            break
        }

        // Player collides Enemies (testing - it kinda works but needs more work)
//        if (contact.bodyA.node?.physicsBody?.categoryBitMask == PhysicsCategories.player.rawValue) && (contact.bodyB.node?.physicsBody?.categoryBitMask == PhysicsCategories.enemies.rawValue) {
//            enemy?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
//        }
        
    }
    
 // MARK: UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        
        let location = player1?.position
        camera!.position = player1!.position
        
        if circle.contains(location!) {
            player1!.isHidden = false
        } else {
            self.isDead = true
            player1?.run(fallDown, completion: {() -> Void in
                self.resultLabel.text = "You Lost"
                self.resultLabel.isHidden = false
                self.player1!.isHidden = true
                self.player1?.removeFromParent()
                self.scene!.view!.isPaused = true
                self.player1!.isHidden = true
                self.player1?.removeFromParent()
            })
            
//            restartScene()
        }
        var index = 0
        for player in alivePlayers{
            followPlayer(location: location!, enemy: player, index: index)
            index += 1
        }
        
    }
}
