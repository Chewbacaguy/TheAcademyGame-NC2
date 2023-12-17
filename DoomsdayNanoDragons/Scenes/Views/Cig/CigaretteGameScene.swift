//
//  PausaCigaretta.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//
import SpriteKit
import SwiftUI

class CigaretteGameScene: SKScene {
    var animationTextures: [SKTexture] = []
    var animatedNode: SKSpriteNode!
    var isAnimationPaused = false
       let startFrame = 19
       let endFrame = 21
    var restartButton: UIButton!
    
    var consecutiveCatches = 0
    var viewModel: CigaretteGameViewModel
    
    
    init(size: CGSize, viewModel: CigaretteGameViewModel) {
        
        self.viewModel = viewModel
        super.init(size: size)
        self.scaleMode = .aspectFill
        createAnimation()
        
        let backgroundImage = SKSpriteNode(imageNamed: "FondoCig")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -1 // Place it behind other nodes
        addChild(backgroundImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
           
            setupRestartButton()
        }


    func createAnimation() {
        for i in 1...27 {
            let texture = SKTexture(imageNamed: "Cig\(i)")
            animationTextures.append(texture)
        }

        animatedNode = SKSpriteNode(texture: animationTextures.first)
        let scale: CGFloat = 0.27
        animatedNode.setScale(scale)
        animatedNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(animatedNode)

        let animationAction = SKAction.animate(with: animationTextures, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animationAction)

        animatedNode.run(repeatAction, withKey: "animationKey")
    }

    
    func setupRestartButton() {
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 63
        let padding: CGFloat = 35 // Adjust padding from the bottom

        restartButton = UIButton(type: .custom)
        restartButton.setTitle("Restart", for: .normal)
        restartButton.setTitleColor(.white, for: .normal)
        restartButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        restartButton.layer.cornerRadius = 3.0
        restartButton.layer.borderWidth = 6.0
        restartButton.layer.borderColor = UIColor.white.cgColor
        restartButton.titleLabel?.font = UIFont(name: "Luckiest Guy", size: 30)

        // Calculate the x position to center the button horizontally
        let screenWidth = UIScreen.main.bounds.width
        let centerX = (screenWidth - buttonWidth) / 2

        // Set the button's frame
        restartButton.frame = CGRect(x: centerX, y: UIScreen.main.bounds.height - buttonHeight - padding, width: buttonWidth, height: buttonHeight)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)

        if let window = view?.window {
            window.addSubview(restartButton)
        }
    }

    
    @objc func restartGame() {
        // Reset necessary game variables and restart the animation
        isAnimationPaused = false
        animatedNode.removeAllActions()
        animatedNode.isHidden = true // Hide the node
        animatedNode.texture = animationTextures.first // Set back to the initial frame
        animatedNode.isHidden = false // Show the node again

        let animationAction = SKAction.animate(with: animationTextures, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animationAction)
        animatedNode.run(repeatAction, withKey: "animationKey")
    }

    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isAnimationPaused else { return } // Do nothing if animation is already paused
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        // Calculate the frame width based on the number of frames
        let frameWidth = self.size.width / CGFloat(animationTextures.count)
        
        // Calculate the tapped frame index based on touch location
        let tappedFrameIndex = Int((touchLocation?.x ?? 0) / frameWidth) + 1
        
        if tappedFrameIndex >= startFrame && tappedFrameIndex <= endFrame{
            print("You tapped the CigCatch frame! You win!")
            consecutiveCatches += 1
            viewModel.incrementScore(by: consecutiveCatches)
        } else {
            print("You missed! You lose!")
            consecutiveCatches = 0

        }
        isAnimationPaused = true
        animatedNode.removeAllActions() // Stop the animation
        
        // Show the appropriate frame
        let imageName = (tappedFrameIndex >= startFrame && tappedFrameIndex <= endFrame) ? "CigCatch" : "CigMiss"
        let texture = SKTexture(imageNamed: imageName)
        animatedNode.texture = texture
        animatedNode.isHidden = false
    }
}

