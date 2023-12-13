//
//  FartingGameView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit


struct ElevatorGameView: View {
    @State private var isAnimationStarted = false
    @State private var isGameOver = false
    @State private var isLeaderboardVisible = false
    @StateObject private var viewModel = ElevatorGameViewModel()

    var body: some View {
        ZStack {
            // Add the SpriteView for your game scene in the background
            SpriteView(scene: ElevatorGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel, isAnimationStarted: $viewModel.isGameRunning, isGameOver: $viewModel.isGameOver))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                
                Text("Tap to start!")
                    .font(Font.custom("Luckiest Guy", size: 30))
                    .foregroundColor(.white)
                
                HStack {
                    Text("15:00")
                        .font(Font.custom("Luckiest Guy", size: 80))
                        .foregroundColor(.black)
                    
                    Text("sec")
                        .font(Font.custom("Luckiest Guy", size: 19))
                        .foregroundColor(.black)
                        .padding(.leading, 7)
                        .padding(.top, 7)
                }
                .padding(-3)
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 200, height: 35)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .stroke(Color.black, lineWidth: 3)
                            .frame(width:200)
                    )
                    .padding(1)
                
                Text("Beat the time")
                    .font(Font.custom("Luckiest Guy", size: 20))
                    .foregroundColor(.black)
                     
                
                Spacer()
                
                Button(action: {
                    // LOGIC FOR BUTTON: When pressed, WHILE pressing, the text changes to WATCH OUT, also when pressed, the game scene loads.
                }) {
                    Text(isGameOver ? "TAP 2 Badge in!" : (isAnimationStarted ? "Tap FAST!" : "TAP 2 Badge in!"))
                        .font(Font.custom("Luckiest Guy", size: 30))
                        .frame(width: 280, height: 72)
                        .padding(10)
                }
                .buttonStyle(IntroButtonStyle())
            }
        }
        .fullScreenCover(isPresented: $isLeaderboardVisible) {
            ElevatorLeaderboardView(topCatches: [5, 6, 7])
        }
    }
}

struct ElevatorGameView_Previews: PreviewProvider {
    static var previews: some View {
        ElevatorGameView()
    }
}

