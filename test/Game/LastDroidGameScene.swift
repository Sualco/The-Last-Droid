//
//  GameScene.swift
//  test
//
//  Created by Claudio Borrelli on 09/12/23.
//
import SwiftData
import SwiftUI
import Foundation
import SpriteKit
import AVFoundation

class LastDroidGameScene: SKScene, SKPhysicsContactDelegate {
    @Environment(\.modelContext) private var context
    @Query(sort: \Partita.playedAt, order: .reverse) var allPartiteSalvate: [Partita]
    var gameLogic: LastDroidGameLogic = LastDroidGameLogic.shared
    
    @State var gameIsDismissed : Bool = false
    
    static var madonna = LastDroidGameScene()
    
    var numberOfHits = 0
    var humanLifePoints = 60
    var bigAndroidLifePoints = 20
    var bigAndroidHits = 0
    let lifeLabel = SKLabelNode (fontNamed: "PressStart2P")
    var human: SKSpriteNode!
    var score = 0
    var lastScore: Int = 0
    var finalScore = 0
    let scoreLabel = SKLabelNode(fontNamed: "PressStart2P")
    var bigAndroids : [SKSpriteNode] = []
    var isInvicible = false
    var lastUpdate: TimeInterval = 0
    var androidCounter: Int = 0
    let maxNumber: Int = 20
   
    var backgroundMusic: AVAudioPlayer?
    var bulletHumanSound: AVAudioPlayer?
    var bulletAndroidSound: AVAudioPlayer?
    var bulletBossSound: AVAudioPlayer?
    
    struct PhysicsCategory {
        static let Android: UInt32 = 1
        static let BigAndroid : UInt32 = 2
        static let Human: UInt32 = 4
        static let Bullet: UInt32 = 8
        static let ABullet: UInt32 = 16
        static let BigBullet: UInt32 = 32
    }
    
    override func didMove(to view: SKView) {
        
        scoreLabel.text = "Score: \(gameLogic.currentScore)"
        scoreLabel.fontSize = 13
        scoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 100)
        scoreLabel.color = .yellow
        addChild(scoreLabel)
        
        updateLifePoints()
        print ("game loaded")
        
        let background = SKSpriteNode(imageNamed: "background")
            background.position = CGPoint(x: size.width / 2, y: size.height / 2)
            background.zPosition = -1
            background.size = CGSize(width: size.width, height: size.height)
            
            addChild(background)
        
        self.physicsWorld.contactDelegate = self
        
        generateBigAndroid()
        
        generateAndroids()
        
        createHuman()
        
        respawnAndroid()
        
        respawnBigAndroid()
        
        updateFinalScore()
        
        
        if let backgroundSoundURL = Bundle.main.url(forResource: "BackgroundEffect", withExtension: "wav") {
                   do {
                       backgroundMusic = try AVAudioPlayer(contentsOf: backgroundSoundURL)
                       backgroundMusic?.numberOfLoops = -1 // Riproduzione in loop infinito
                       backgroundMusic?.volume = 0.1
                       backgroundMusic?.play()
                   } catch {
                       print("Errore durante il caricamento del suono di background: \(error.localizedDescription)")
                   }
               }
        
        let bulletHumanSoundURL = Bundle.main.url(forResource: "AppleBullet", withExtension: "wav")
                do {
                    try bulletHumanSound = AVAudioPlayer(contentsOf: bulletHumanSoundURL!)
                    bulletHumanSound?.volume = 0.8
                    bulletHumanSound?.prepareToPlay()
                } catch {
                    print("Errore durante il caricamento del file audio: \(error.localizedDescription)")
                }
        
        let bulletAndroidSoundURL = Bundle.main.url(forResource: "AndroidLaser", withExtension: "wav")
                do {
                    try bulletAndroidSound = AVAudioPlayer(contentsOf: bulletAndroidSoundURL!)
                    bulletAndroidSound?.volume = 0.1
                    bulletAndroidSound?.prepareToPlay()
                } catch {
                    print("Errore durante il caricamento del file audio: \(error.localizedDescription)")
                }
        
        let bulletBossSoundURL = Bundle.main.url(forResource: "BossLaser", withExtension: "wav")
                do {
                    try bulletBossSound = AVAudioPlayer(contentsOf: bulletBossSoundURL!)
                    bulletBossSound?.volume = 0.1
                    bulletBossSound?.prepareToPlay()
                } catch {
                    print("Errore durante il caricamento del file audio: \(error.localizedDescription)")
                }
    }
    
    func updateFinalScore () {
        let currentScore = gameLogic.currentScore
             if currentScore > finalScore{
                 finalScore = currentScore
                 print ("generato \(finalScore)")
      }
    }
    
    func updateLifePoints () {
    
            self.children.filter { $0.name == "lifePoints" }.forEach { $0.removeFromParent() }

            let fullHearts = humanLifePoints / 20
            let halfHearts = (humanLifePoints % 20) / 10
            
            for i in 0..<fullHearts {
                let heart = SKSpriteNode(imageNamed: "fullheart")
                heart.name = "lifePoints"
                heart.size = CGSize(width: 20, height: 20)
                heart.position = CGPoint(x: UIScreen.main.bounds.minX + 40 + CGFloat(i * 30), y: UIScreen.main.bounds.maxY - 85)
                addChild(heart)
            }

            
            for i in 0..<halfHearts {
                let heart = SKSpriteNode(imageNamed: "halfheart")
                heart.name = "lifePoints"
                heart.size = CGSize(width: 20, height: 20)
                let xOffset = CGFloat(fullHearts * 30)
                heart.position = CGPoint(x: UIScreen.main.bounds.minX + 40 + xOffset + CGFloat(i * 30), y: UIScreen.main.bounds.maxY - 85)
                addChild(heart)
            }
        for _ in 0..<(3 - fullHearts - halfHearts) {
            let heart = SKSpriteNode(imageNamed: "emptyheart")
            heart.name = "lifeNode"
            heart.size = CGSize(width: 20, height: 20)
            let xOffset = CGFloat((fullHearts + halfHearts) * 30)
            heart.position = CGPoint(x: UIScreen.main.bounds.minX + 40 + xOffset, y: UIScreen.main.bounds.maxY - 85)
            addChild(heart)
        }
    }
    func respawnBigAndroid () {
        var respawnDelay = TimeInterval(CGFloat(2))
        var increaseDifficultyScore = 400
        run(SKAction.sequence([SKAction.wait(forDuration: respawnDelay), SKAction.run {
            self.generateBigAndroid()
            
            if self.gameLogic.currentScore >= increaseDifficultyScore {
                respawnDelay -= 0.2
                increaseDifficultyScore += 200
            }
            self.respawnBigAndroid()
        }]))
    }
    
    func respawnAndroid() {
            var respawnDelay = TimeInterval(CGFloat(8))
            var increaseDifficultyScore = 200
            
            run(SKAction.sequence([SKAction.wait(forDuration: respawnDelay), SKAction.run {
                self.generateAndroids()
                if self.gameLogic.currentScore >= increaseDifficultyScore {
                    respawnDelay -= 0.5
                    increaseDifficultyScore += 200
                }
                
                self.respawnAndroid()
            }]))
        }
    
   func generateBigAndroid () { // generate big android from 100 to 100 intervals
      let thresold = 100
       let currentScore = (gameLogic.currentScore / thresold)
       
       
           if currentScore > lastScore {
               let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
               let randomY = CGFloat(700)
               let noRandomSize1 = CGSize(width: CGFloat(70), height: CGFloat(80))
               let randomDelay = TimeInterval(1)
               let newbigAndroid = bigAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize1, delay: randomDelay)
               bigAndroids.append (newbigAndroid)
               lastScore = currentScore
               print ("generato \(lastScore)")
           }
    }
    
    func generateAndroids () {
        
        if (androidCounter <= maxNumber){
            
            for _ in 1...1 {
                let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
                let randomY = CGFloat(600)
                let noRandomSize = CGSize(width: CGFloat(30), height: CGFloat(50))
                let randomDelay = TimeInterval(arc4random_uniform(5) + 1)
                androidCounter+=1
                createAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize, delay: randomDelay)
            }
            for _ in 1...1 {
                let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
                let randomY = CGFloat(550)
                let noRandomSize = CGSize(width: CGFloat(30), height: CGFloat(40))
                let randomDelay = TimeInterval(arc4random_uniform(5) + 1)
                androidCounter+=1
                createAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize, delay: randomDelay)
            }
            for _ in 1...1 {
                let randomX = CGFloat(arc4random_uniform(UInt32(size.width))) / 2
                let randomY = CGFloat(500)
                let noRandomSize = CGSize(width: CGFloat(30), height: CGFloat(40))
                let randomDelay = TimeInterval(arc4random_uniform(5) + 1)
                androidCounter+=1
                createAndroid(pos: CGPoint(x: randomX, y: randomY), size: noRandomSize, delay: randomDelay)
            }
        }
    }
    
    func bigAndroid (pos: CGPoint, size: CGSize, delay: TimeInterval) -> SKSpriteNode {
        let bigAndroidTexture = SKTexture(imageNamed: "bigandroid")
        let newbigAndroid = SKSpriteNode(texture: bigAndroidTexture,size: size)
        
        newbigAndroid.position = pos
        newbigAndroid.name = "big android"
        
        //physics properties
        newbigAndroid.physicsBody = SKPhysicsBody(rectangleOf: newbigAndroid.frame.size)
        newbigAndroid.physicsBody?.isDynamic = false
        newbigAndroid.physicsBody!.affectedByGravity = false
        newbigAndroid.physicsBody!.usesPreciseCollisionDetection = true
        newbigAndroid.physicsBody!.categoryBitMask = PhysicsCategory.BigAndroid
        newbigAndroid.physicsBody!.contactTestBitMask = PhysicsCategory.Bullet
        self.addChild(newbigAndroid)
        
        //animation
        let moveRight = SKAction.move(by: CGVector(dx: 200, dy: 0), duration: 1.0)
        let moveLeft = SKAction.move(by: CGVector(dx: -200, dy: 0), duration: 1.0)
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([SKAction.wait(forDuration: delay),moveRight,wait,moveLeft,wait])
        let repeatSequence = SKAction.repeatForever(sequence)
        newbigAndroid.run(repeatSequence)
        
        let fireActionBigAndroid = SKAction.run {
            if !newbigAndroid.hasActions() {
                return
            }
            self.bigAndroidBullet(textureName: "bulletBA", position: newbigAndroid.position)
            }

        let shootAndWaitAndroid = SKAction.sequence([SKAction.wait(forDuration: 2.0),fireActionBigAndroid])
            let repeatAndroidShooting = SKAction.repeatForever(shootAndWaitAndroid)
        newbigAndroid.run(repeatAndroidShooting)
        return newbigAndroid
//        self.addChild(bigAndroid)
    }
    
    
    func createAndroid (pos: CGPoint,size: CGSize, delay: TimeInterval){
        let androidTexture = SKTexture(imageNamed: "android")
        let android = SKSpriteNode(texture: androidTexture,size: size)
        
        android.position = pos
        android.name = "androide"
        
        let xRange: SKRange = SKRange(lowerLimit: +android.size.width, upperLimit: scene!.size.width)
        let xConstraint = SKConstraint.positionX(xRange)
        android.constraints = [xConstraint]
        
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
        
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([SKAction.wait(forDuration: delay),moveRight,wait,moveLeft,wait])
        let repeatSequence = SKAction.repeatForever(sequence)
        
        android.run (repeatSequence)
        
        let fireAction = SKAction.run {
            if !android.hasActions() {
                return
            }
            self.androidBullet(textureName: "bulletA", position: android.position)
        }
        
        let delayFire = TimeInterval(.random(in: 2...6))
            let fireSequence = SKAction.sequence([SKAction.wait(forDuration: delayFire), fireAction])
            let repeatFire = SKAction.repeatForever(fireSequence)

        android.run(repeatFire)
    }
    
    func bigAndroidBullet (textureName: String, position: CGPoint) {
        let bigBulletTexture = SKTexture(imageNamed: textureName)
        let bigBullet = SKSpriteNode(texture: bigBulletTexture, size: CGSize(width: 40, height: 40))
        bigBullet.name = "Big Bullet"
        bigBullet.position = CGPoint(x: position.x, y: position.y - 20)

        // Physics properties
    bigBullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
    bigBullet.physicsBody?.isDynamic = true
    bigBullet.physicsBody!.affectedByGravity = false
    bigBullet.physicsBody!.usesPreciseCollisionDetection = true
    bigBullet.physicsBody!.categoryBitMask = PhysicsCategory.BigBullet
    bigBullet.physicsBody!.contactTestBitMask = PhysicsCategory.Human
    bigBullet.physicsBody!.collisionBitMask = 0
        
    
    addChild(bigBullet)
    
        // Bullet movement
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: -800), duration: 4.0)
        let wait = SKAction.wait(forDuration: 1.0)
        let delete = SKAction.removeFromParent()
        let sequenceOfActions = SKAction.sequence([moveUp,wait, delete])

    bigBullet.run(sequenceOfActions)
        bulletBossSound?.play()
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
        bulletAndroidSound?.play()
    }
    
    
    func createHuman () {
        let humanTexture = SKTexture (imageNamed: "human")
        human = SKSpriteNode(texture: humanTexture)
        human.size = CGSize(width: 90, height: 90)
        human.position =  CGPoint(x: UIScreen.main.bounds.width / 2, y:70)
        human.name = "Human"
        
        // physics properties
        
        human.physicsBody = SKPhysicsBody (rectangleOf: human.frame.size)
        human.physicsBody?.isDynamic = false
        human.physicsBody!.affectedByGravity = false
        human.physicsBody!.usesPreciseCollisionDetection = true
        human.physicsBody!.categoryBitMask = PhysicsCategory.Human
        human.physicsBody!.contactTestBitMask = PhysicsCategory.ABullet
        human.physicsBody!.contactTestBitMask = PhysicsCategory.BigBullet
        
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
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 800), duration: 1.5)
        let delete = SKAction.removeFromParent()
        let sequenceOfActions = SKAction.sequence([moveUp,delete])
        
        bullet.run(sequenceOfActions)
        bulletHumanSound?.play()
    }
    
    func runInvincibilityAnimation() {
        // Esegui l'animazione di lampeggiamento
        let blinkAction = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.fadeIn(withDuration: 0.1)])
        let blinkSequence = SKAction.repeat(blinkAction, count: 10)
        
        // Aggiungi azioni aggiuntive, se necessario
        
        human.run(blinkSequence) {
            // Fine dell'animazione di lampeggiamento
            self.isInvicible = false
            // Reimposta l'invincibilità
        }
    }
    
   
    
    override func update(_ delay: TimeInterval) {
        // GAME OVER CONDITION
        if self.isGameOver { self.finishGame() }
        if self.lastUpdate == 0 { self.lastUpdate = delay }
        self.lastUpdate = delay
        
        for bigAndroid in bigAndroids {
            let moveRight = SKAction.move(by: CGVector(dx: 200, dy: 0), duration: 1.0)
            let moveLeft = SKAction.move(by: CGVector(dx: -200, dy: 0), duration: 1.0)
            let wait = SKAction.wait(forDuration: 0.5)
            let sequence = SKAction.sequence([SKAction.wait(forDuration: delay), moveRight, wait, moveLeft, wait])
            let repeatSequence = SKAction.repeatForever(sequence)

            bigAndroid.run(repeatSequence)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let minX = CGFloat(20)
            let maxX = CGFloat(370)
            let clampedX = max(min(location.x,maxX), minX)
            let newLocation = CGPoint(x: clampedX, y: human.position.y)
            let move = SKAction.move(to: newLocation, duration: 0.1)
            human.run(move)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask == PhysicsCategory.Bullet ? contact.bodyB : contact.bodyA
        let collision2 = contact.bodyA.categoryBitMask == PhysicsCategory.ABullet ? contact.bodyB : contact.bodyA
        let collision3 = contact.bodyA.categoryBitMask == PhysicsCategory.Bullet ? contact.bodyB : contact.bodyA
        //let collision4 = contact.bodyA.categoryBitMask == PhysicsCategory.BigBullet ? contact.bodyB : contact.bodyA
        
        if collision.categoryBitMask == PhysicsCategory.Android {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            androidCounter-=1
            gameLogic.currentScore += 20
            scoreLabel.text = "Score: \(gameLogic.currentScore)"
            
           
        }
       if collision3.categoryBitMask == PhysicsCategory.BigAndroid {
           bigAndroidHits += 1
           bigAndroidLifePoints -= 10
           gameLogic.currentScore += 40
           scoreLabel.text = "Score: \(gameLogic.currentScore)"
           if bigAndroidHits >= 2 {
               contact.bodyA.node?.removeFromParent()
               
            }
           contact.bodyB.node?.removeFromParent()
        }
        
        
        if collision2.categoryBitMask == PhysicsCategory.Human {
            if !isInvicible {
                numberOfHits += 1
                humanLifePoints -= 10
                

                // Aggiorna la UI dei cuori
                updateLifePoints()

                // Esegui l'animazione di lampeggiamento e l'invincibilità
                runInvincibilityAnimation()

                if numberOfHits >= 6 {
                    contact.bodyA.node?.removeFromParent()
                    humanLifePoints = 0
                    removeAllActions()
                }
            } else {
                runInvincibilityAnimation()
            }

            contact.bodyB.node?.removeFromParent()
        }
    }
}

// GAME OVER PRESENTATION
extension LastDroidGameScene {
    var isGameOver: Bool {
        updateFinalScore()
        return gameLogic.isGameOver || humanLifePoints == 0
        
    }
    
    private func finishGame() {
        backgroundMusic?.stop()
        gameIsDismissed = true
        gameLogic.isGameOver = true
    }
}
