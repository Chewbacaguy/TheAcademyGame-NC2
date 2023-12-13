//
//  PausaCigaretta.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//
import SpriteKit
import SwiftUI


class CigaretteGameScene: SKScene {
    @ObservedObject var viewModel: CigaretteGameViewModel
    @Binding var isAnimationStarted: Bool
    @Binding var isGameOver: Bool
    
    var animationTextures: [SKTexture] = []
    var animatedNode: SKSpriteNode!
    var repeatAction: SKAction!
    var frameNumber = 0 // Track the frame number
    var isTouchingScreen = false
    var isFrame21Tapped = false
    
    init(size: CGSize, viewModel: CigaretteGameViewModel, isAnimationStarted: Binding<Bool>, isGameOver: Binding<Bool>) {
        self.viewModel = viewModel
        self._isAnimationStarted = isAnimationStarted
        self._isGameOver = isGameOver
        super.init(size: size)
        
        // Set the background image
        let backgroundImage = SKSpriteNode(imageNamed: "FondoCig")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -1 // Place it behind other nodes
        addChild(backgroundImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAnimation() {
        for i in 1...22 {
            let texture = SKTexture(imageNamed: "Cig\(i)")
            animationTextures.append(texture)
        }
        
        animatedNode = SKSpriteNode(texture: animationTextures.first)
        let scale: CGFloat = 0.27
        animatedNode.setScale(scale)
        animatedNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(animatedNode)
        
        let animationAction = SKAction.animate(with: animationTextures, timePerFrame: 0.1)
        repeatAction = SKAction.repeat(animationAction, count: 1)
        
        animatedNode.run(repeatAction, withKey: "animationKey")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            // Restart the game
            isGameOver = false
            viewModel.resetGame()
            createAnimation()
            frameNumber = 0 // Reset the frame number
        } else if isAnimationStarted {
            // Handle button click during the game, e.g., stop the animation
            isTouchingScreen = true
        } else {
            // Start the animation
            isAnimationStarted = true
            viewModel.isGameRunning = true
            createAnimation()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchingScreen {
            if isFrame21Tapped {
                // You tapped on frame 21
                viewModel.incrementScore()
                isFrame21Tapped = false
                animatedNode.removeAction(forKey: "animationKey")
                createAnimation()
            } else {
                // You didn't tap on frame 21
                viewModel.isGameRunning = false
                isGameOver = true
                stopAnimation()
                // Show leaderboard and allow restart/exit
            }
            isTouchingScreen = false
        }
    }
    
    func stopAnimation() {
        animatedNode.removeAction(forKey: "animationKey")
    }
}
