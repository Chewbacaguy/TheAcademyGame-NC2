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
    
    
    private var countdownTimer: Timer?
    private var timeRemaining = 60 // Initial time remaining in seconds
    
    
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
        vasiliThinking = SKSpriteNode(imageNamed: "VasiliThinking")
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
        vasiliAngry.isHidden = false
        vasiliLooking.isHidden = true
        santoNormal.isHidden = false
        santoFarting.isHidden = true
        stefanoNormal.isHidden = false
        stefanoFarting.isHidden = true
        
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
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var scoreIncrementAction: SKAction?
    
    private func handleButtonPress(_ isPressed: Bool) {
        if isPressed {
            // Start incrementing the score by 5 points per second
            if scoreIncrementAction == nil {
                let incrementAction = SKAction.repeatForever(
                    SKAction.sequence([
                        SKAction.wait(forDuration: 1.0),
                        SKAction.run {
                            self.viewModel.incrementScoreBy(5)
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
    
    // Handle Vasilly's state transitions
    private func handleVasillyState() {
        if viewModel.vasillyTurnCount == 0 {
            viewModel.incrementScoreBy(5) // Increment score while Vasilly is "thinking"
        } else {
            if isTouchingScreen {
                turnVasillyToAngry()
            }
        }
    }
    
    
    // Transition Vasilly to "angry" state
    private func turnVasillyToAngry() {
        vasiliThinking.isHidden = true
        vasiliLooking.isHidden = true
        vasiliAngry.isHidden = false
        let returnToThinking = SKAction.run {
            self.vasiliThinking.isHidden = false
            self.vasiliLooking.isHidden = true
            self.vasiliAngry.isHidden = true
        }
        let waitAction = SKAction.wait(forDuration: 3)
        self.run(SKAction.sequence([waitAction, returnToThinking]))
    }
    
    override func didMove(to view: SKView) {
        // Start the countdown timer when the scene is presented
        startCountdownTimer()
    }
    
    
    // Update method
    override func update(_ currentTime: TimeInterval) {
        if  !isGameOver {
            updateTimerLabel()
            handleButtonPress(isButtonPressed)
        }
        
    }
}
