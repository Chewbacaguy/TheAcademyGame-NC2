//
//  FartingGameScene.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//


import SpriteKit
import SwiftUI

class FartingGameScene: SKScene {
    @ObservedObject var viewModel: FartingGameViewModel
    @Binding var isAnimationStarted: Bool
    @Binding var isGameOver: Bool
    @Binding var isButtonPressed: Bool
    @Binding var isSantoFarting: Bool
    @Binding var isStefanoFarting: Bool
    
    private var score = 0
    private var scoreLabel: SKLabelNode?
    
    
    private var isVasillyAngry = false
    private var countdownTimer: Timer?
    private var timeRemaining = 60 // Initial time remaining in seconds
    private var scoreIncrementAction: SKAction?
    private var scoreDecrementAction: SKAction?
    
    var animationTextures: [SKTexture] = []
    var animatedNode: SKSpriteNode!
    var repeatAction: SKAction!
    var frameNumber = 0 // Track the frame number
    var isTouchingScreen = false
    var vasillyTurnCount = 0 // Count for Vasilly turning
    
    // Declare sprite nodes for your assets
    var vasiliThinking: SKSpriteNode!
    var vasiliLooking: SKSpriteNode!
    var vasiliAngry: SKSpriteNode!
    var santoNormal: SKSpriteNode!
    var santoFarting: SKSpriteNode!
    var stefanoNormal: SKSpriteNode!
    var stefanoFarting: SKSpriteNode!
    
    
    // Add these properties to your scene class
    private var lastUpdateTime: TimeInterval = 0
    private var isButtonPressTimerRunning = false
    private var buttonPressStartTime: TimeInterval = 0
    private var buttonPressDuration: TimeInterval = 0
    
    // Create SKActions for sprite animations
    private var santoNormalAction: SKAction?
    private var santoFartingAction: SKAction?
    private var stefanoNormalAction: SKAction?
    private var stefanoFartingAction: SKAction?
    
    
    // Declare texture variables
    private var santoNormalTextures: [SKTexture]!
    private var santoFartingTextures: [SKTexture]!
    private var stefanoNormalTextures: [SKTexture]!
    private var stefanoFartingTextures: [SKTexture]!
    
    private var scoreUpdateTimer: Timer?
    
    
    var startTime: Bool
    var timerLabel: SKLabelNode?
    
    @objc var fartButton: UIButton!
    //var buttonSprite: SKSpriteNode!
    
    //startTime:  Binding<Bool>,
    
    init(size: CGSize, viewModel: FartingGameViewModel, isAnimationStarted: Binding<Bool>, isGameOver: Binding<Bool>,  isButtonPressed: Binding<Bool>, isSantoFarting: Binding<Bool>, isStefanoFarting: Binding<Bool>) {
        self.viewModel = viewModel
        self._isAnimationStarted = isAnimationStarted
        self._isGameOver = isGameOver
        self._isButtonPressed = isButtonPressed
        self._isSantoFarting = isSantoFarting
        self._isStefanoFarting = isStefanoFarting
        self.startTime = false
        
        
        
        
        super.init(size: size)
        
        // Create a white background node with rounded corners and black border
        let backgroundNodeScore = SKShapeNode(rect: CGRect(x: -5, y: -5, width: 180, height: 42), cornerRadius: 15)
        backgroundNodeScore.position = CGPoint(x: -35, y:710)
        backgroundNodeScore.fillColor = SKColor.white
        backgroundNodeScore.strokeColor = SKColor.black
        backgroundNodeScore.lineWidth = 2
        
        
        // Initialize score label
        scoreLabel = SKLabelNode(fontNamed: "Luckiest Guy")
        scoreLabel?.fontSize = 20
        scoreLabel?.fontColor = SKColor.black
        scoreLabel?.text = "Score: 0"
        scoreLabel?.position = CGPoint(x: 110, y: 725)
        scoreLabel?.horizontalAlignmentMode = .right
        scoreLabel?.verticalAlignmentMode = .center
        
        // Add the score label to the scene
        
        addChild(backgroundNodeScore)
        addChild(scoreLabel!)
        
        
        // Set the background image
        let backgroundImage = SKSpriteNode(imageNamed: "FondoFarting")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -1 // Place it behind other nodes
        addChild(backgroundImage)
        
        
        // Create a white background node with rounded corners and black border
        let backgroundNode = SKShapeNode(rect: CGRect(x: -5, y: -5, width: 140, height: 40), cornerRadius: 15)
        backgroundNode.position = CGPoint(x: -35, y: 660)
        backgroundNode.fillColor = SKColor.white
        backgroundNode.strokeColor = SKColor.black
        backgroundNode.lineWidth = 2
        
        // Set up the timer label
        timerLabel = SKLabelNode(fontNamed: "Luckiest Guy")
        timerLabel?.fontSize = 20
        timerLabel?.fontColor = SKColor.black
        timerLabel?.text = "60 sec" // Set your initial text
        timerLabel?.position = CGPoint(x: 10, y: 675)
        timerLabel?.horizontalAlignmentMode = .left
        timerLabel?.verticalAlignmentMode = .center
        
        // Add the background and timer label to the scene
        addChild(backgroundNode)
        addChild(timerLabel!)
        
        // Load and set up your assets
        vasiliLooking = SKSpriteNode(imageNamed: "VasiliLooking")
        vasiliThinking = SKSpriteNode(imageNamed: "VasilliThinking")
        vasiliAngry = SKSpriteNode(imageNamed: "VasiliAngry")
        santoNormal = SKSpriteNode(imageNamed: "SantoNormal")
        santoFarting = SKSpriteNode(imageNamed: "SantoFarting")
        stefanoNormal = SKSpriteNode(imageNamed: "StefanoNormal")
        stefanoFarting = SKSpriteNode(imageNamed: "StefanoFarting")
        
        // Position your assets as needed
        vasiliThinking.position = CGPoint(x: 195, y: 500)
        vasiliAngry.position = CGPoint(x: 195, y: 500)
        vasiliLooking.position = CGPoint(x: 195, y: 500)
        
        santoNormal.position = CGPoint(x: 275, y: 320)
        santoFarting.position = CGPoint(x: 275, y: 320)
        
        stefanoNormal.position = CGPoint(x: 115, y: 260)
        stefanoFarting.position =  CGPoint(x: 115, y: 260)
        
        // Set the initial visibility of the assets
        vasiliThinking.isHidden = true
        vasiliAngry.isHidden = true
        vasiliLooking.isHidden = false
        santoNormal.isHidden = false
        santoFarting.isHidden = true
        stefanoNormal.isHidden = false
        stefanoFarting.isHidden = true
        
        // Add your assets as children of the scene
        addChild(vasiliThinking)
        addChild(vasiliAngry)
        addChild(vasiliLooking)
        addChild(santoNormal)
        addChild(santoFarting)
        addChild(stefanoNormal)
        addChild(stefanoFarting)
        
        // Initialize texture variables as arrays with a single texture each
        santoNormalTextures = [SKTexture(imageNamed: "SantoNormal")]
        santoFartingTextures = [SKTexture(imageNamed: "SantoFarting")]
        stefanoNormalTextures = [SKTexture(imageNamed: "StefanoNormal")]
        stefanoFartingTextures = [SKTexture(imageNamed: "StefanoFarting")]
        
        // Initialize action variables
        santoNormalAction = SKAction.animate(with: santoNormalTextures, timePerFrame: 0.1)
        santoFartingAction = SKAction.animate(with: santoFartingTextures, timePerFrame: 0.1)
        stefanoNormalAction = SKAction.animate(with: stefanoNormalTextures, timePerFrame: 0.1)
        stefanoFartingAction = SKAction.animate(with: stefanoFartingTextures, timePerFrame: 0.1)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFartButton() {
         //EXPERIMENT
         let buttonWidth: CGFloat = 200
         let buttonHeight: CGFloat = 63
         let padding: CGFloat = 35 // Adjust padding from the bottom
         
         
         fartButton = UIButton(type: .custom)
         fartButton.setTitle("Tap 2 Fart", for: .normal)
         fartButton.setTitleColor(.white, for: .normal)
         fartButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
         fartButton.layer.cornerRadius = 3.0
         fartButton.layer.borderWidth = 6.0
         fartButton.layer.borderColor = UIColor.white.cgColor
         fartButton.titleLabel?.font = UIFont(name: "Luckiest Guy", size: 30)
         
         // Calculate the x position to center the button horizontally
         let screenWidth = UIScreen.main.bounds.width
         let centerX = (screenWidth - buttonWidth) / 2
         
         // Set the button's frame
         fartButton.frame = CGRect(x: centerX, y: UIScreen.main.bounds.height - buttonHeight - padding, width: buttonWidth, height: buttonHeight)
         fartButton.addTarget(self, action: #selector(getter: fartButton), for: .touchUpInside)
         fartButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
         fartButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
         
         self.view?.addSubview(fartButton)
         
         
     }
     
    @objc func buttonTouchDown() {
        fartButton.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        isButtonPressed = true
    }

    @objc func buttonTouchUpInside() {
        fartButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        isButtonPressed = false
    }
     
     
     // Function to start the countdown timer
     private func startCountdownTimer() {
         countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
             guard let self = self else {
                 timer.invalidate()
                 return
             }
             
             self.timeRemaining -= 1
             self.updateTimerLabel()
             
             if self.timeRemaining <= 0 {
                 // Time's up, stop the timer
                 timer.invalidate()
                 self.viewModel.isGameRunning = false
                 self.isGameOver = true
                 //   self.showLeaderboardsView()
                 
                 // Handle game over logic...
             }
         }
     }
     
     // Function to update the timer label
     private func updateTimerLabel() {
         if let timerLabel = timerLabel {
             timerLabel.text = "\(timeRemaining) sec"
         }
     }
     
     
     // Handle button press and score updates
     private func handleButtonPress(isButtonPressed: Bool) {
         if isButtonPressed {
             // Handle button pressed logic here
             showSantoAndStefanoFarting()
             // Increment score by 5 points
             viewModel.incrementScoreBy(20)
         }
         else{
            // hideSantoAndStefanoFarting()
         }
     }
     
     
     
     private func hideSantoAndStefanoFarting() {
         santoNormal.isHidden = false
         santoFarting.isHidden = true
         stefanoNormal.isHidden = false
         stefanoFarting.isHidden = true
     }
     
     private func showSantoAndStefanoFarting() {
         santoNormal.isHidden = true
         santoFarting.isHidden = false
         stefanoNormal.isHidden = true
         stefanoFarting.isHidden = false
     }
     
     
    // Method to schedule Vasilly's turn at a random interval
    private func scheduleVasillyTurn() {
        let randomTime = Double.random(in: 2...5) // Reduced time between 2 to 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) { [weak self] in
            self?.handleVasillyTurn()
        }
    }
    
    private func handleVasillyTurn() {
        vasillyTurnCount += 1

        if vasillyTurnCount <= 5 {
            showVasillyLooking()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }

                if self.isButtonPressed {
                    self.showVasillyAngry()
                    self.resetScore()

                    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...3)) {
                        self.showVasillyThinking()
                        self.scheduleVasillyTurn() // Schedule next turn
                    }
                } else {
                    self.showVasillyThinking()
                    self.scheduleVasillyTurn() // Schedule next turn
                }
            }
        }
    }
    
    private func resetScore() {
        score = 0
        scoreLabel?.text = "Score: \(score)"
    }
    
    private func showVasillyThinking() {
        vasiliThinking.isHidden = false
        vasiliLooking.isHidden = true
        vasiliAngry.isHidden = true
        isVasillyAngry = false
    }
     
     // Show Vasilly in the "looking" state
     private func showVasillyLooking() {
         vasiliThinking.isHidden = true
         vasiliLooking.isHidden = false
         vasiliAngry.isHidden = true
     }
     
     // Show Vasilly in the "angry" state
     private func showVasillyAngry() {
         vasiliThinking.isHidden = true
         vasiliLooking.isHidden = true
         vasiliAngry.isHidden = false
         isVasillyAngry = true // Set a flag to track Vasilly's angry state
     }
     
     override func didMove(to view: SKView) {
         // Start the countdown timer when the scene is presented
         showVasillyThinking()
         startCountdownTimer()
         setupFartButton()
         scheduleVasillyTurn()
         
     }
     
     private func showLeaderboardsView() {
         // Implement the logic to show the leaderboards view here
         // You can transition to a new scene or present a SwiftUI view here
     }
     
     
    override func update(_ currentTime: TimeInterval) {
        if isButtonPressed {
            showSantoAndStefanoFarting()
            incrementScore()
        } else {
            hideSantoAndStefanoFarting()
        }
    }
    
    private func incrementScore() {
        score += 2 // Increment the score by 5 points
        scoreLabel?.text = "Score: \(score)" // Update the score label
    }
    
}
