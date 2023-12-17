//
//  CigaretteGameView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct CigaretteGameView: View {
    @StateObject private var viewModel = CigaretteGameViewModel()
    @State private var isGameOver = false
    
    var body: some View {
        ZStack {
            // Add the SpriteView for your game scene in the background
            SpriteView(scene: CigaretteGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("\(viewModel.score)")
                    .font(Font.custom("Luckiest Guy", size: 80))
                    .position(x: 200, y: 25)
                    .foregroundColor(.white)
                
                Text("Tap to Catch")
                    .font(Font.custom("Luckiest Guy", size: 30))
                    .position(x: 200, y: 210)
                    .foregroundColor(.white)
                
                /*
                Button(action: {
                    if !isGameOver {
                        if viewModel.currentFrame == 32 {
                            viewModel.incrementScore()
                        } else {
                            isGameOver = true
                            viewModel.resetGame()
                        }
                    } else {
                        isGameOver = false
                        viewModel.resetGame()
                    }
                }) {
                    Text(isGameOver ? "TAP 4 a Trick" : "TAP 2 CATCH")
                        .font(Font.custom("Luckiest Guy", size: 30))
                        .frame(width: 280, height: 72)
                        .padding(10)
                }
                .buttonStyle(IntroButtonStyle())
                 
                 */
            }
        }
    }
}


#Preview {
    CigaretteGameView()
}
