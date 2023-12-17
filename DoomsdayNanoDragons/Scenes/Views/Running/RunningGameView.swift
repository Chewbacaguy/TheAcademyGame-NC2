//
//  RunningGameView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit

import GameplayKit


struct RunningGameView: View {
     @State private var isAnimationStarted = false
        @State private var isGameOver = false
        @State private var isLeaderboardVisible = false
        @StateObject private var viewModel = RunningGameViewModel()
        @State private var showGameScene = false // New state to control the game scene visibility
   // @ObservedObject var coordinator = RunningGameCoordinator()

    
    var body: some View {
        ZStack {
            // background
            Image("Background")
                          .resizable()
                          .scaledToFill()
                          .edgesIgnoringSafeArea(.all)
                      
            if showGameScene {
                            /* Import and use RunningGameScene here within SpriteView
                SpriteView(scene: scene)
                                  .edgesIgnoringSafeArea(.all)
                                  .transition(.opacity)
                             */
            } else {
                VStack {
                    Spacer()
                    
                    Text("Strongest Run")
                        .font(Font.custom("Luckiest Guy", size: 50))
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .frame(width:450, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 17)
                                        .fill(Color.white)
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width:450, height: 100)
                                    
                                )
                        )
                        .padding(-10)
                    
                    HStack {
                        Text("Score")
                            .font(Font.custom("Luckiest Guy", size: 25))
                            .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                        
                        Text("240")
                            .font(Font.custom("Luckiest Guy", size: 25))
                            .foregroundColor(.black)
                        
                    }
                    
                    HStack {
                        Button(action: {
                            // LOGIC FOR BUTTON: When pressed, WHILE pressing, the text changes to WATCH OUT, also when pressed, the game scene loads.
                            showGameScene.toggle()
                        }) {
                            Text(isGameOver ? "TAP 2 Run!" : (isAnimationStarted ? "Yuhu!" : "TAP 2 Run!"))
                                .font(Font.custom("Luckiest Guy", size: 30))
                                .frame(width: 280, height: 72)
                                .padding(10)
                        }
                        .buttonStyle(IntroButtonStyle())
                    }
                    
                    Spacer()
                    
                    HStack {
                        
                        
                        Spacer() // This spacer pushes the following items to the center
                        
                        Button(action: {
                            // Handle exit button click
                            // NAVIGATE BACK TO CONTENTVIEW
                        }) {
                            Text("EXIT")
                                .font(Font.custom("Luckiest Guy", size: 30))
                                .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                                .frame(width: 138.77, height: 53)
                                .background(Color.white)
                                .cornerRadius(3.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.black, lineWidth: 6)
                                )
                                .padding(.top, -25)
                            
                        }
                        
                        Spacer() // This spacer pushes the following item to the end
                        
                        Text("Tap 2 jump")
                            .font(Font.custom("Luckiest Guy", size: 25))
                            .foregroundColor(.white)
                            .padding(.trailing) // Add some right padding
                    }
                    
                    
                }
                
            }
            
            
            
        }
        .fullScreenCover(isPresented: $isLeaderboardVisible) {
            //RunningLeaderboardView(topCatches: [5, 6, 7])
        }
    }
}


 

struct RunningGameView_Previews: PreviewProvider {
    static var previews: some View {
        RunningGameView()
    }
}

