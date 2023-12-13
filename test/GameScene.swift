//
//  GameScene.swift
//  test
//
//  Created by Claudio Borrelli on 09/12/23.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var numberOfHits = 0
    var humanLifePoints = 60
    let lifeLabel = SKLabelNode (fontNamed: "PressStart2P")
    var human: SKSpriteNode!
    var bigAndroid : SKSpriteNode!
    let scoreLabel = SKLabelNode(fontNamed: "PressStart2P")
    var score = 0
    var lastScore: Int = 0
    
    struct PhysicsCategory {
        static let Android: UInt32 = 1
        static let BigAndroid : UInt32 = 2
        static let Human: UInt32 = 4
        static let Bullet: UInt32 = 8
        static let ABullet: UInt32 = 16
    }
    
    override func didMove(to view: SKView) {
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 20
        scoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 95)
        addChild(scoreLabel)
        
        lifeLabel.text = "Life Points : \(humanLifePoints)"
        lifeLabel.fontSize = 20
        lifeLabel.position = CGPoint(x: UIScreen.main.bounds.minX + 100, y: UIScreen.main.bounds.minY + 750)
        addChild(lifeLabel)
        print ("game loaded")
        
        let background = SKSpriteNode(imageNamed: "background")
            background.position = CGPoint(x: size.width / 2, y: size.height / 2)
            background.zPosition = -1
            addChild(background)
        
        self.physicsWorld.contactDelegate = self
        
        generateBigAndroid()
        
        generateAndroids()
        
        createHuman()
        
        respawnAndroid()
        
        respawnBigAndroid()
        
        
    }
    func respawnBigAndroid () {
        let respawnDelay = TimeInterval(CGFloat(2))
        run(SKAction.sequence([SKAction.wait(forDuration: respawnDelay), SKAction.run {
            
            self.generateBigAndroid ()
            self.respawnBigAndroid()
        }]))
    }
    
    func respawnAndroid() {
            let respawnDelay = TimeInterval(CGFloat(8))
            run(SKAction.sequence([SKAction.wait(forDuration: respawnDelay), SKAction.run {
                self.generateAndroids()
                self.respawnAndroid()
            }]))
        }
    
   func generateBigAndroid () {
        
       let thresold = 100
       let currentScore = (score / thresold)
        
        
     if currentScore > lastScore {
         let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
         let randomY = CGFloat(700)
         let noRandomSize1 = CGSize(width: CGFloat(70), height: CGFloat(70))
         let randomDelay = TimeInterval(1)
         bigAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize1, delay: randomDelay)
         lastScore = currentScore
         print ("generato")
     }
    }
    
    func generateAndroids () {
        
        for _ in 1...2 {
                let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
                let randomY = CGFloat(600)
                let noRandomSize = CGSize(width: CGFloat(50), height: CGFloat(50))
                let randomDelay = TimeInterval(arc4random_uniform(5) + 1)

                createAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize, delay: randomDelay)
            }
        for _ in 1...2 {
                let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
                let randomY = CGFloat(500)
                let noRandomSize = CGSize(width: CGFloat(50), height: CGFloat(50))
                let randomDelay = TimeInterval(arc4random_uniform(5) + 1)

                createAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize, delay: randomDelay)
            }
        for _ in 1...2 {
                let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
                let randomY = CGFloat(400)
                let noRandomSize = CGSize(width: CGFloat(50), height: CGFloat(50))
                let randomDelay = TimeInterval(arc4random_uniform(5) + 1)

                createAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize, delay: randomDelay)
            }
        
        
        
    }
    
    func bigAndroid ( pos: CGPoint, size: CGSize, delay: TimeInterval) {
        let bigAndroidTexture = SKTexture(imageNamed: "android")
        bigAndroid = SKSpriteNode(texture: bigAndroidTexture,size: size)
        
        bigAndroid.position = pos
        bigAndroid.name = "big android"
        
        //physics properties
        bigAndroid.physicsBody = SKPhysicsBody(rectangleOf: bigAndroid.frame.size)
        bigAndroid.physicsBody?.isDynamic = false
        bigAndroid.physicsBody!.affectedByGravity = false
        bigAndroid.physicsBody!.usesPreciseCollisionDetection = true
        bigAndroid.physicsBody!.categoryBitMask = PhysicsCategory.BigAndroid
        bigAndroid.physicsBody!.contactTestBitMask = PhysicsCategory.Bullet
        
        
        //animation
        let moveRight = SKAction.move(by: CGVector(dx: 200, dy: 0), duration: 1.0)
        let moveLeft = SKAction.move(by: CGVector(dx: -200, dy: 0), duration: 1.0)
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([SKAction.wait(forDuration: delay),moveRight,wait,moveLeft,wait])
        let repeatSequence = SKAction.repeatForever(sequence)
        bigAndroid.run(repeatSequence)
        
        let fireActionBigAndroid = SKAction.run {
            if !self.bigAndroid.hasActions() {
                return
            }
            self.androidBullet(textureName: "bulletBA", position: self.bigAndroid.position)
            
           
            }

        let shootAndWaitAndroid = SKAction.sequence([SKAction.wait(forDuration: 2.0),fireActionBigAndroid])
            let repeatAndroidShooting = SKAction.repeatForever(shootAndWaitAndroid)
            run(repeatAndroidShooting)
        self.addChild(bigAndroid)
    }
    
    
    func createAndroid (pos: CGPoint,size: CGSize, delay: TimeInterval){
        let androidTexture = SKTexture(imageNamed: "bigandroid")
        let android = SKSpriteNode(texture: androidTexture,size: size)
        
        android.position = pos
        android.name = "androide"
        
        
        //physics properties
        
        android.physicsBody = SKPhysicsBody (rectangleOf: android.frame.size)
        android.physicsBody?.isDynamic = false
        android.physicsBody!.affectedByGravity = false
        android.physicsBody!.usesPreciseCollisionDetection = true
        android.physicsBody!.categoryBitMask = PhysicsCategory.Android
        android.physicsBody!.contactTestBitMask = PhysicsCategory.Bullet
        self.addChild(android)
        
        //animations
        
        let moveRight = SKAction.move(by: CGVector (dx: 200, dy: 0), duration: 1.0)
        
        let moveLeft = SKAction.move(by: CGVector(dx: -200, dy: 0), duration: 1.0)
        //let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([SKAction.wait(forDuration: delay),moveRight,wait,moveLeft,wait])
        let repeatSequence = SKAction.repeatForever(sequence)
        
        android.run (repeatSequence)
        
        let fireAction = SKAction.run {
            if !android.hasActions() {
            return
        }
                if size.width < 80 {
                    self.androidBullet(textureName: "bulletA", position: android.position)
                } else {
                    self.androidBullet(textureName: "bulletBA", position: android.position)
                }
            }
            let delayFire = TimeInterval(4)
            let fireSequence = SKAction.sequence([SKAction.wait(forDuration: delayFire), fireAction])
            let repeatFire = SKAction.repeatForever(fireSequence)

        android.run(repeatFire)
    
        
    }
    
    func androidBullet(textureName: String, position: CGPoint) {
            let aBulletTexture = SKTexture(imageNamed: textureName)
            let aBullet = SKSpriteNode(texture: aBulletTexture, size: CGSize(width: 30, height: 30))
            aBullet.name = "Bullet"
            aBullet.position = CGPoint(x: position.x, y: position.y - 20)

            // Physics properties
        aBullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        aBullet.physicsBody?.isDynamic = true
        aBullet.physicsBody!.affectedByGravity = false
        aBullet.physicsBody!.usesPreciseCollisionDetection = true
        aBullet.physicsBody!.categoryBitMask = PhysicsCategory.ABullet
        aBullet.physicsBody!.contactTestBitMask = PhysicsCategory.Human
        aBullet.physicsBody!.collisionBitMask = 0
            
        
        addChild(aBullet)
        

            // Bullet movement
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: -800), duration: 4.0)
            let wait = SKAction.wait(forDuration: 1.0)
            let delete = SKAction.removeFromParent()
            let sequenceOfActions = SKAction.sequence([moveUp,wait, delete])

        aBullet.run(sequenceOfActions)
        
    }
    
   
    
    
    func createHuman () {
        let humanTexture = SKTexture (imageNamed: "human")
        human = SKSpriteNode(texture: humanTexture)
        human.size = CGSize(width: 70, height: 70)
        human.position =  CGPoint(x: UIScreen.main.bounds.width / 2, y:70)
        human.name = "Human"
        
        // physics properties
        
        human.physicsBody = SKPhysicsBody (rectangleOf: human.frame.size)
        human.physicsBody?.isDynamic = false
        human.physicsBody!.affectedByGravity = false
        human.physicsBody!.usesPreciseCollisionDetection = true
        human.physicsBody!.categoryBitMask = PhysicsCategory.Human
        human.physicsBody!.contactTestBitMask = PhysicsCategory.Android
        self.addChild(human)
        
        let shootingFire = SKAction.run {
                self.createBullet(texture: "apple", pos: self.human.position)
            }

            let shootAndWait = SKAction.sequence([shootingFire, SKAction.wait(forDuration: 2.0)])
            let repeatShooting = SKAction.repeatForever(shootAndWait)
            run(repeatShooting)

    
    }
    
    func createBullet (texture: String,pos:CGPoint) {
        
        let bulletTexture = SKTexture(imageNamed: "apple")
        let bullet = SKSpriteNode(texture: bulletTexture, size: CGSize(width: 20, height: 20))
        bullet.name = "Bullet"
        bullet.position = CGPoint ( x: human.position.x, y: human.position.y + 100)
        
        // physics properties
        
        bullet.physicsBody = SKPhysicsBody (rectangleOf: bullet.frame.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.usesPreciseCollisionDetection = true
        bullet.physicsBody!.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody!.contactTestBitMask = PhysicsCategory.Android
        bullet.physicsBody!.collisionBitMask = 0
        addChild(bullet)
        
        //bullet movement
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 800), duration: 2.0)
        let delete = SKAction.removeFromParent()
        let sequenceOfActions = SKAction.sequence([moveUp,delete])
        
        bullet.run(sequenceOfActions)
    }
    
   
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let newLocation = CGPoint(x: location.x, y: human.position.y)
            let move = SKAction.move(to: newLocation, duration: 0.1)
            human.run(move)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask == PhysicsCategory.Bullet ? contact.bodyB : contact.bodyA
        let collision2 = contact.bodyA.categoryBitMask == PhysicsCategory.ABullet ? contact.bodyB : contact.bodyA
        let collision3 = contact.bodyA.categoryBitMask == PhysicsCategory.Bullet ? contact.bodyB : contact.bodyA
        
        if collision.categoryBitMask == PhysicsCategory.Android {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            score += 10
            scoreLabel.text = "Score: \(score)"
        } 
       if collision3.categoryBitMask == PhysicsCategory.BigAndroid {
           
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
           bigAndroid.removeAllActions()
            score += 50
            scoreLabel.text = "Score: \(score)"
        }
        
        
        
        if collision2.categoryBitMask == PhysicsCategory.Human {
            numberOfHits += 1
            humanLifePoints -= 10
            lifeLabel.text = "Life Points : \(humanLifePoints)"
            //contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            if numberOfHits >= 6 {
                contact.bodyA.node?.removeFromParent()
                humanLifePoints = 0
            removeAllActions()
            }
        }
        
      
    }
    
}
