//
//  FartingGameView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit


struct FartingGameView: View {
    @State private var isAnimationStarted = false
    @State private var isGameOver = false
    @State private var isLeaderboardVisible = false
    @StateObject private var viewModel = FartingGameViewModel()

    var body: some View {
        ZStack {
            // Add the SpriteView for your game scene in the background
            SpriteView(scene: FartingGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel, isAnimationStarted: $viewModel.isGameRunning, isGameOver: $viewModel.isGameOver))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Farting is Fun!")
                    .font(Font.custom("Luckiest Guy", size: 36))
                    .foregroundColor(.white)
                    .frame(maxWidth: 150, alignment: .topTrailing)
                    .frame(width: 140, alignment: .trailing)
                    .position(x:300, y: 46)
                
                VStack{
                    Text("60 pts")
                        .font(Font.custom("Luckiest Guy", size: 20))
                        .padding(11)
                        .padding(.leading, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                
                                .overlay(
                                    RoundedRectangle(cornerRadius: 17)
                                        .fill(Color.white)
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width:140)
                                    
                                )
                        )
                        .position(x:34, y:-280)
                    
                    Text("52 sec")
                        .font(Font.custom("Luckiest Guy", size: 19))
                        .padding(11)
                        .padding(.leading, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 17)
                                        .fill(Color.white)
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width:120)
                                )
                        )
                        .position(x:30, y:-400)
                }
                
                Spacer()
                
                Button(action: {
                    // LOGIC FOR BUTTON: When pressed, WHILE pressing, the text changes to WATCH OUT, also when pressed, the game scene loads.
                }) {
                    Text(isGameOver ? "TAP 2 Fart!" : (isAnimationStarted ? "WATCH OUT!" : "TAP 2 FART!"))
                        .font(Font.custom("Luckiest Guy", size: 30))
                        .frame(width: 280, height: 72)
                        .padding(10)
                }
                .buttonStyle(IntroButtonStyle())
            }
        }
        .fullScreenCover(isPresented: $isLeaderboardVisible) {
            FartingLeaderboardView(topCatches: [5, 6, 7])
        }
    }
}

struct FartingGameView_Previews: PreviewProvider {
    static var previews: some View {
        FartingGameView()
    }
}

