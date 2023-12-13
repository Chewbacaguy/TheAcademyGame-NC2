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
    
    var animationTextures: [SKTexture] = []
    var animatedNode: SKSpriteNode!
    var repeatAction: SKAction!
    var frameNumber = 0 // Track the frame number
    var isTouchingScreen = false
    var isFrame21Tapped = false
    var timeRemaining = 60 // Total time for the game
    var vasillyTurnCount = 0 // Count for Vasilly turning
    
    // Declare sprite nodes for your assets
    var vasiliNormal: SKSpriteNode!
    var vasiliLooking: SKSpriteNode!
    var santoNormal: SKSpriteNode!
    var santoFarting: SKSpriteNode!
    var stefanoNormal: SKSpriteNode!
    var stefanoFarting: SKSpriteNode!
    
    
    init(size: CGSize, viewModel: FartingGameViewModel, isAnimationStarted: Binding<Bool>, isGameOver: Binding<Bool>) {
        self.viewModel = viewModel
        self._isAnimationStarted = isAnimationStarted
        self._isGameOver = isGameOver
        super.init(size: size)
        
        // Set the background image
        let backgroundImage = SKSpriteNode(imageNamed: "FondoFarting")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -1 // Place it behind other nodes
        addChild(backgroundImage)
        
        
        // Load and set up your assets
        vasiliNormal = SKSpriteNode(imageNamed: "VasiliNormal")
        vasiliLooking = SKSpriteNode(imageNamed: "VasiliLooking")
        santoNormal = SKSpriteNode(imageNamed: "SantoNormal")
        santoFarting = SKSpriteNode(imageNamed: "SantoFarting")
        stefanoNormal = SKSpriteNode(imageNamed: "StefanoNormal")
        stefanoFarting = SKSpriteNode(imageNamed: "StefanoFarting")
        
        // Position your assets as needed
        vasiliNormal.position = CGPoint(x: 195, y: 500)
        vasiliLooking.position = CGPoint(x: 195, y: 500)
        
        
        santoNormal.position = CGPoint(x: 275, y: 320)
        santoFarting.position = CGPoint(x: 275, y: 320)
        
        
        stefanoNormal.position = CGPoint(x: 115, y: 260)
        stefanoFarting.position =  CGPoint(x: 115, y: 260)
        
        // Add your assets as children of the scene
        addChild(vasiliNormal)
        addChild(vasiliLooking)
        addChild(santoNormal)
        addChild(santoFarting)
        addChild(stefanoNormal)
        addChild(stefanoFarting)
        
        // Set the initial visibility of the assets
        vasiliNormal.isHidden = false
        vasiliLooking.isHidden = true
        santoNormal.isHidden = false
        santoFarting.isHidden = true
        stefanoNormal.isHidden = false
        stefanoFarting.isHidden = true
        
        
        // Load animation textures
        for i in 1...22 {
            let texture = SKTexture(imageNamed: "YourAnimationPrefix\(i)")
            animationTextures.append(texture)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isAnimationStarted && !isGameOver {
            // Update game timer
            if timeRemaining > 0 {
                timeRemaining -= 1
                
                // Check for Vasilly turning
                if timeRemaining < 60 && vasillyTurnCount < 5 {
                    // Implement random chance for Vasilly turning
                    let random = Int.random(in: 0..<100)
                    if random < 5 { // Adjust this value for your desired chance (e.g., 5%)
                        vasillyTurnCount += 1
                        // Handle Vasilly turning here
                        
                        // Change Vasilly's state to "looking"
                    }
                }
                
                // Handle scoring based on actions and states
                if isTouchingScreen {
                    if isFrame21Tapped {
                        // You tapped on frame 21
                        viewModel.incrementScore()
                        animatedNode.removeAction(forKey: "animationKey")
                        // Handle scoring based on Vasilly's state here
                        if vasillyTurnCount == 0 {
                            viewModel.incrementScoreBy(5)
                        } else {
                            viewModel.decrementScoreBy(40)
                        }
                    } else {
                        // You didn't tap on frame 21
                        viewModel.isGameRunning = false
                        isGameOver = true
                        stopAnimation()
                    }
                    isTouchingScreen = false
                } else {
                    // Not touching the screen, decrement score or do nothing
                    if vasillyTurnCount == 0 {
                        viewModel.decrementScoreBy(1)
                    }
                }
            } else {
                // Game over when the timer reaches 0
                viewModel.isGameRunning = false
                isGameOver = true
                stopAnimation()
            }
        }
    }
    
    func stopAnimation() {
        animatedNode.removeAction(forKey: "animationKey")
    }
}
