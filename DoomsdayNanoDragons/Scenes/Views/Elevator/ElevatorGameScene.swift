//
//  ElevatorGameScene.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//

//  ElevatorGameScene.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//


import SpriteKit
import SwiftUI
import AVFoundation

class ElevatorGameScene: SKScene {
    @ObservedObject var viewModel: ElevatorGameViewModel
    @Binding var isAnimationStarted: Bool
    @Binding var isGameOver: Bool
    var audioPlayer: AVAudioPlayer?
    @Binding var isButtonPressed: Bool
    var animationTextures: [SKTexture] = []
    var animatedNode: SKSpriteNode!
    var repeatAction: SKAction!
    var frameNumber = 0 // Track the frame number
    var isTouchingScreen = false
    var timeRemaining = 60 // Total time for the game
   
    
    // Declare sprite nodes for your assets
    var nagaHappy: SKSpriteNode!
    var nagaRight: SKSpriteNode!
    var nagaLeft: SKSpriteNode!
   
    
    
    init(size: CGSize, viewModel: ElevatorGameViewModel, isButtonPressed:Binding<Bool>, isAnimationStarted: Binding<Bool>, isGameOver: Binding<Bool>) {
        self.viewModel = viewModel
        self._isAnimationStarted = isAnimationStarted
        self._isGameOver = isGameOver
        self._isButtonPressed = isButtonPressed
        super.init(size: size)
        
        // Set the background image
        let backgroundImage = SKSpriteNode(imageNamed: "Elevetor1")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -1 // Place it behind other nodes
        addChild(backgroundImage)
        
        
        nagaHappy = SKSpriteNode(imageNamed: "NagHappy")
        nagaRight = SKSpriteNode(imageNamed: "NagMad")
        nagaLeft = SKSpriteNode(imageNamed: "NagMad1")
        nagaRight.position = CGPoint(x: 200, y: 350)
        nagaLeft.position = CGPoint(x: 200, y: 350)
        nagaHappy.position = CGPoint(x: 200, y: 350)
        
        let nagaScale = 0.5 as CGFloat
        nagaHappy.setScale(nagaScale)
        nagaRight.setScale(nagaScale)
        nagaLeft.setScale(nagaScale)
        
        
        nagaHappy.isHidden = false
        nagaRight.isHidden = true
        nagaLeft.isHidden = true
        
        
        addChild(nagaLeft)
        addChild(nagaRight)
        addChild(nagaHappy)
        
        
        
        // Load animation textures
        for i in 1...22 {
            let texture = SKTexture(imageNamed: "YourAnimationPrefix\(i)")
            animationTextures.append(texture)
        }
    }
    
    private var isNagaRightVisible = false
    var toggleTimer: Timer?
    var timeSinceLastToggle: TimeInterval = 0
    let toggleInterval: TimeInterval = 1.0
    var lastUpdateTime: TimeInterval = 0
    
    func toggleNaga() {
        isNagaRightVisible = !isNagaRightVisible

        nagaRight.isHidden = !isNagaRightVisible
        nagaLeft.isHidden = isNagaRightVisible
    }

    func stopTogglingNaga() {
        toggleTimer?.invalidate()
        toggleTimer = nil
    }
    
    func startTogglingNaga() {
        toggleTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.toggleNaga()
        }
    }
    
    override func didMove(to view: SKView) {
        lastUpdateTime = 0
        // Other setup code...
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playDing(){
        guard let url = Bundle.main.url(forResource: "elevator", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not load grunt sound file")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Calculate time elapsed since last frame
        
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        // Increment the time since the last toggle
        timeSinceLastToggle += deltaTime

        // Check if it's time to toggle
        if timeSinceLastToggle >= toggleInterval {
            nagaHappy.isHidden = true
            toggleNaga()
            timeSinceLastToggle = 0
        }
        
        if isGameOver{
            playDing()
        }

        // Other update logic...
    }
    
    func stopAnimation() {
        animatedNode.removeAction(forKey: "animationKey")
    }
}
