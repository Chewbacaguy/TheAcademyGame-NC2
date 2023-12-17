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
    
    
    var startTime: Bool
    var timerLabel: SKLabelNode?
    
    
    
    
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
        
        // Set the background image
        let backgroundImage = SKSpriteNode(imageNamed: "FondoFarting")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -1 // Place it behind other nodes
        addChild(backgroundImage)
        
        //EXPERIMENT
        let buttonTexture = SKTexture(imageNamed: "FartButton")
        let buttonSprite = SKSpriteNode(texture: buttonTexture)
        buttonSprite.position = CGPoint(x: 200, y: 90) // Adjust the position as needed
        buttonSprite.name = "gameButton" // Set a name to identify the button later
        addChild(buttonSprite)
        
        
        
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
        
        // Add your assets as children of the scene
        addChild(vasiliThinking)
        addChild(vasiliAngry)
        addChild(vasiliLooking)
        addChild(santoNormal)
        addChild(santoFarting)
        addChild(stefanoNormal)
        addChild(stefanoFarting)
        
        // Set the initial visibility of the assets
        vasiliThinking.isHidden = false
        vasiliAngry.isHidden = true
        vasiliLooking.isHidden = true
        santoNormal.isHidden = false
        santoFarting.isHidden = true
        stefanoNormal.isHidden = false
        stefanoFarting.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    private func handleButtonPress() {
        if isButtonPressed {
            // Start incrementing the score by 5 points per second
            showSantoAndStefanoFarting()
            if scoreIncrementAction == nil {
                let incrementAction = SKAction.repeatForever(
                    SKAction.sequence([
                        SKAction.wait(forDuration: 1.0),
                        SKAction.run {
                            self.viewModel.incrementScoreBy(3)
                        }
                    ])
                )
                scoreIncrementAction = incrementAction
                run(incrementAction, withKey: "scoreIncrement")
            }
        } else {
            // Stop incrementing the score
            removeAction(forKey: "scoreIncrement")
            scoreIncrementAction = nil
            // Start decrementing Score
            let decrementAction = SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run {
                        self.viewModel.decrementScoreBy(1)
                    }
                ])
            )
            scoreDecrementAction = decrementAction
            run(decrementAction, withKey: "scoreDecrement")
        }
    }
    
    
    private func hideSantoAndStefanoFarting() {
        isSantoFarting = false
        isStefanoFarting = false
        santoNormal.isHidden = false
        santoFarting.isHidden = true
        stefanoNormal.isHidden = false
        stefanoFarting.isHidden = true
    }
    
    private func showSantoAndStefanoFarting() {
        isSantoFarting = true
        isStefanoFarting = true
        santoNormal.isHidden = true
        santoFarting.isHidden = false
        stefanoNormal.isHidden = true
        stefanoFarting.isHidden = false
    }
    

    // Handle Vasilly's state transitions
    private func handleVasillyState() {
        if viewModel.vasillyTurnCount < 5 {
            // Alternate between thinking and looking states
            let isThinking = viewModel.vasillyTurnCount % 2 == 0
            if isThinking {
                // Increment score while Vasilly is "thinking"
                viewModel.incrementScoreBy(5)
            }

            // Check if Santo and Stefano are farting and deduct points if necessary
            if isSantoFarting && isStefanoFarting {
                viewModel.decrementScoreBy(40)
                showVasillyAngry()
            }

            // Increment Vasilly's turn count
            viewModel.incrementVasillyTurnCount()
            if !isVasillyAngry {
                // If Vasilly was not shown angry, make Vasilly turn back to looking
                showVasillyLooking()
            }

            // Wait for a random time between 7-15 seconds before Vasilly turns again
            let randomTime = Double.random(in: 7...15)
            DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) {
                self.handleVasillyState() // Turn Vasilly again
            }
        }
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
        startCountdownTimer()
    }
    
    private func showLeaderboardsView() {
        // Implement the logic to show the leaderboards view here
        // You can transition to a new scene or present a SwiftUI view here
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if !isGameOver {
            updateTimerLabel()
            handleButtonPress()
            handleVasillyState()
        }
    }
}
