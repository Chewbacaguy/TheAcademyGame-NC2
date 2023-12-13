//
//  CigaretteGameView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit
struct CigaretteGameView: View {
    @State private var isAnimationStarted = false
    @State private var isGameOver = false
    @State private var isLeaderboardVisible = false
    @StateObject private var viewModel = CigaretteGameViewModel()

    var body: some View {
        ZStack {
            // Add the SpriteView for your game scene in the background
            SpriteView(scene: CigaretteGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel, isAnimationStarted: $viewModel.isGameRunning, isGameOver: $viewModel.isGameOver))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("\(viewModel.score)")
                    .font(Font.custom("Luckiest Guy", size: 80))
                    .position(x: 200, y: 60)
                    .foregroundColor(.white)
                
                Text("Catches")
                    .font(Font.custom("Luckiest Guy", size: 30))
                    .position(x: 200, y: -210)
                    .foregroundColor(.white)
                
                Button(action: {
                    if !isAnimationStarted {
                        // Start the animation
                        isAnimationStarted = true
                        viewModel.isGameRunning = true
                    } else if !isGameOver {
                        // Handle button click during the game, e.g., stop the animation
                        if viewModel.currentFrame == 32 {
                            viewModel.incrementScore()
                        } else {
                            viewModel.isGameRunning = false
                            isGameOver = true
                        }
                    } else {
                        // Restart the game
                        isGameOver = false
                        viewModel.resetGame()
                    }
                }) {
                    Text(isGameOver ? "TAP 4 a Trick" : (isAnimationStarted ? "TAP 2 CATCH" : "TAP 4 a Trick"))
                        .font(Font.custom("Luckiest Guy", size: 30))
                        .frame(width: 280, height: 72)
                        .padding(10)
                }
                .buttonStyle(IntroButtonStyle())
            }
        }
        .fullScreenCover(isPresented: $isLeaderboardVisible) {
            CigLeaderboardView(topCatches: [5,6,7])
               }
    }
}




#Preview {
    CigaretteGameView()
}
