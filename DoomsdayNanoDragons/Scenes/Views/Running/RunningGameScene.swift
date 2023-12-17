//
//  GameScene.swift
//  DinoRunner
//


import SpriteKit
import GameplayKit

class RunningGameScene: SKScene, SKPhysicsContactDelegate {
    
    //nodes
    var gameNode: SKNode!
    var groundNode: SKNode!
    var backgroundNode: SKNode!
    var cactusNode: SKNode!
    var dinosaurNode: SKNode!
    var birdNode: SKNode!
    
    //score
    var scoreNode: SKLabelNode!
    var resetInstructions: SKLabelNode!
    var score = 0 as Int
    
    //sound effects
    let jumpSound = SKAction.playSoundFileNamed("dino.assets/sounds/jump", waitForCompletion: false)
    let dieSound = SKAction.playSoundFileNamed("dino.assets/sounds/die", waitForCompletion: false)
    
    //sprites
    var dinoSprite: SKSpriteNode!
    
    //spawning vars
    var spawnRate = 1.5 as Double
    var timeSinceLastSpawn = 0.0 as Double
    
    //generic vars
    var groundHeight: CGFloat?
    var dinoYPosition: CGFloat?
    var groundSpeed = 500 as CGFloat
    
    //consts
    let dinoHopForce = 700 as Int
    let cloudSpeed = 50 as CGFloat
    let moonSpeed = 10 as CGFloat
    
    let background = 0 as CGFloat
    let foreground = 1 as CGFloat
    
    //collision categories
    let groundCategory = 1 << 0 as UInt32
    let dinoCategory = 1 << 1 as UInt32
    let cactusCategory = 1 << 2 as UInt32
    let birdCategory = 1 << 3 as UInt32
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
            
        var backgroundNode: SKSpriteNode!
        // ground
            groundNode = SKNode()
            groundNode.zPosition = foreground // Set groundNode's z-position to foreground
            createAndMoveGround()
            addCollisionToGround()
            
        //background elements
        let backgroundTexture = SKTexture(imageNamed: "Background")
           backgroundNode = SKSpriteNode(texture: backgroundTexture)
           backgroundNode.zPosition = background // Set backgroundNode's z-position to background
           backgroundNode.size = CGSize(width: self.size.width, height: self.size.height) // Set the size of the background to match the scene size
           backgroundNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2) // Center the background
           
           
   
        
        //dinosaur
        dinosaurNode = SKNode()
        dinosaurNode.zPosition = foreground
        createDinosaur()
        
        //cacti
        cactusNode = SKNode()
        cactusNode.zPosition = foreground
        
        //birds
        birdNode = SKNode()
        birdNode.zPosition = foreground
        
        //score
        score = 0
        scoreNode = SKLabelNode(fontNamed: "Luckiest Guy")
        scoreNode.fontSize = 30
        scoreNode.zPosition = foreground
        scoreNode.text = "Score: 0"
        scoreNode.fontColor = SKColor.gray
        scoreNode.position = CGPoint(x: 150, y: 100)
        
        //reset instructions
        resetInstructions = SKLabelNode(fontNamed: "Luckiest Guy")
        resetInstructions.fontSize = 30
        resetInstructions.text = "Tap to Restart"
        resetInstructions.fontColor = SKColor.white
        resetInstructions.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //parent game node
        gameNode = SKNode()
        gameNode.addChild(backgroundNode)
        gameNode.addChild(groundNode)
        gameNode.addChild(dinosaurNode)
        gameNode.addChild(cactusNode)
        gameNode.addChild(scoreNode)
        gameNode.addChild(resetInstructions)
        self.addChild(gameNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(gameNode.speed < 1.0){
            resetGame()
            return
        }
        
        for _ in touches {
            if let groundPosition = dinoYPosition {
                if dinoSprite.position.y <= groundPosition && gameNode.speed > 0 {
                    dinoSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dinoHopForce))
                    run(jumpSound)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(gameNode.speed > 0){
            groundSpeed += 0.2
            
            score += 1
            scoreNode.text = "Score: \(score/5)"
            
            if(currentTime - timeSinceLastSpawn > spawnRate){
                timeSinceLastSpawn = currentTime
                spawnRate = Double.random(in: 1.0 ..< 3.5)
                
                if(Int.random(in: 0...10) < 8){
                    spawnCactus()
                } else {
                   
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(hitCactus(contact) || hitBird(contact)){
            run(dieSound)
            gameOver()
        }
    }
    
    func hitCactus(_ contact: SKPhysicsContact) -> Bool {
        return contact.bodyA.categoryBitMask & cactusCategory == cactusCategory ||
            contact.bodyB.categoryBitMask & cactusCategory == cactusCategory
    }
    
    func hitBird(_ contact: SKPhysicsContact) -> Bool {
        return contact.bodyA.categoryBitMask & birdCategory == birdCategory ||
                contact.bodyB.categoryBitMask & birdCategory == birdCategory
    }
    
    func resetGame() {
        gameNode.speed = 1.0
        timeSinceLastSpawn = 0.0
        groundSpeed = 500
        score = 0
        
        cactusNode.removeAllChildren()
        birdNode.removeAllChildren()
        
        resetInstructions.fontColor = SKColor.white
        
        let dinoTexture1 = SKTexture(imageNamed: "dinoRight")
        let dinoTexture2 = SKTexture(imageNamed: "dinoLeft")
        dinoTexture1.filteringMode = .nearest
        dinoTexture2.filteringMode = .nearest
        
        let runningAnimation = SKAction.animate(with: [dinoTexture1, dinoTexture2], timePerFrame: 0.12)
        
        dinoSprite.position = CGPoint(x: self.frame.size.width * 0.15, y: dinoYPosition!)
        dinoSprite.run(SKAction.repeatForever(runningAnimation))
    }
    
    func gameOver() {
        gameNode.speed = 0.0
        
        resetInstructions.fontColor = SKColor.gray
        
        let deadDinoTexture = SKTexture(imageNamed: "dinoDead")
        deadDinoTexture.filteringMode = .nearest
        
        dinoSprite.removeAllActions()
        dinoSprite.texture = deadDinoTexture
    }
    
    func createAndMoveGround() {
            let screenWidth = self.frame.size.width
            
            // ground texture
            let groundTexture = SKTexture(imageNamed: "ground")
            groundTexture.filteringMode = .nearest
            
            groundHeight = groundTexture.size().height
            
            // ground actions
            let moveGroundLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
            let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0.0, duration: 0.0)
            let groundLoop = SKAction.sequence([moveGroundLeft, resetGround])
            
            // ground nodes
            let numberOfGroundNodes = 1 + Int(ceil(screenWidth / groundTexture.size().width))
            
            for i in 0 ..< numberOfGroundNodes {
                let node = SKSpriteNode(texture: groundTexture)
                node.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                node.position = CGPoint(x: CGFloat(i) * groundTexture.size().width, y: 0.0)
                node.zPosition = -5
                groundNode.addChild(node)
                node.run(SKAction.repeatForever(groundLoop))
            }
        
        }
        
        func addCollisionToGround() {
            let groundContactNode = SKNode()
            groundContactNode.position = CGPoint(x: 0, y: groundHeight! - 30)
            groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 3, height: groundHeight!))
            groundContactNode.physicsBody?.friction = 0.0
            groundContactNode.physicsBody?.isDynamic = false
            groundContactNode.physicsBody?.categoryBitMask = groundCategory
            
            groundNode.addChild(groundContactNode)
        }
    
   
   
    func createDinosaur() {
        let screenWidth = self.frame.size.width
        let dinoScale = 1.8 as CGFloat
        
        //textures
        let dinoTexture1 = SKTexture(imageNamed: "dinoRight")
        let dinoTexture2 = SKTexture(imageNamed: "dinoLeft")
        dinoTexture1.filteringMode = .nearest
        dinoTexture2.filteringMode = .nearest
        
        let runningAnimation = SKAction.animate(with: [dinoTexture1, dinoTexture2], timePerFrame: 0.12)
        
        dinoSprite = SKSpriteNode()
        dinoSprite.size = dinoTexture1.size()
        dinoSprite.setScale(dinoScale)
        dinosaurNode.addChild(dinoSprite)
        
        let physicsBox = CGSize(width: dinoTexture1.size().width * dinoScale,
                                height: dinoTexture1.size().height * dinoScale)
        
        dinoSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
        dinoSprite.physicsBody?.isDynamic = true
        dinoSprite.physicsBody?.mass = 1.0
        dinoSprite.physicsBody?.categoryBitMask = dinoCategory
        dinoSprite.physicsBody?.contactTestBitMask = birdCategory | cactusCategory
        dinoSprite.physicsBody?.collisionBitMask = groundCategory
        
        dinoYPosition = getGroundHeight() + dinoTexture1.size().height * dinoScale
        dinoSprite.position = CGPoint(x: screenWidth * 0.2, y: 430)//dinoYPosition!)
        dinoSprite.run(SKAction.repeatForever(runningAnimation))
    }
    
    func spawnCactus() {
        let cactusTextures = ["cactus1", "cactus2", "cactus3", "cactus4"]
        let cactusScale = 0.95 as CGFloat
        
        //texture
        let cactusTexture = SKTexture(imageNamed: cactusTextures.randomElement()!)
        cactusTexture.filteringMode = .nearest
        
        //sprite
        let cactusSprite = SKSpriteNode(texture: cactusTexture)
        cactusSprite.setScale(cactusScale)
        
        //physics
        let contactBox = CGSize(width: cactusTexture.size().width * cactusScale,
                                height: cactusTexture.size().height * cactusScale)
        cactusSprite.physicsBody = SKPhysicsBody(rectangleOf: contactBox)
        cactusSprite.physicsBody?.isDynamic = true
        cactusSprite.physicsBody?.mass = 1.0
        cactusSprite.physicsBody?.categoryBitMask = cactusCategory
        cactusSprite.physicsBody?.contactTestBitMask = dinoCategory
        cactusSprite.physicsBody?.collisionBitMask = groundCategory
       
        //add to scene
        cactusNode.addChild(cactusSprite)
        //animate
        animateCactus(sprite: cactusSprite, texture: cactusTexture)
    }
    
    func animateCactus(sprite: SKSpriteNode, texture: SKTexture) {
        let screenWidth = self.frame.size.width
        let distanceOffscreen = 50.0 as CGFloat
        let distanceToMove = screenWidth + distanceOffscreen + texture.size().width
        
        //actions
        let moveCactus = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let removeCactus = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveCactus, removeCactus])
        
        sprite.position = CGPoint(x: distanceToMove, y: getGroundHeight() + texture.size().height)
        sprite.run(moveAndRemove)
    }
    
   
    func getGroundHeight() -> CGFloat {
        if let gHeight = groundHeight {
            return gHeight
        } else {
            print("Ground size wasn't previously calculated")
            exit(0)
        }
    }
    
}
