//
//  CigaretteGameView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit

struct CigaretteGameView: View {
    @StateObject private var viewModel = CigaretteGameViewModel()
    @State private var isLeaderboardVisible = false
    
    
    var body: some View {
        ZStack {
            // Add the SpriteView for your game scene in the background
            SpriteView(scene: CigaretteGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                
                
                
                NavigationLink(destination: RunningGameView()) {
                    Text(viewModel.isGameRunning ? "TAP TO CATCH" : "TAP 4 a trick")
                        .font(Font.custom("Luckiest Guy", size: 30))
                        .frame(width: 280, height: 72)
                        .padding(10)
                }
                .buttonStyle(IntroButtonStyle())
                
                // Leaderboard view (toggle visibility)
                if isLeaderboardVisible {
                    CigLeaderboardView(topCatches: [10, 8, 6]) // Replace with your actual leaderboard data
                        .onTapGesture {
                            // Handle leaderboard tap
                        }
                }
            }
        }
    }
    
    
}




#Preview {
    CigaretteGameView()
}
