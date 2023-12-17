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
    @State private var isButtonPressed = false
    //@GestureState private var isButtonPressed = false
    @State private var isSantoFarting = false
    @State private var isStefanoFarting = false
    @State private var isLeaderboardVisible = false
    @State private var startTime = true
    @Binding var time: TimeInterval
    @Binding var currentTime: TimeInterval
    @ObservedObject private var viewModel = FartingGameViewModel()
    
    
    
    var body: some View {
        ZStack {
            SpriteView(scene: FartingGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel, isAnimationStarted: $isAnimationStarted, isGameOver: $isGameOver, isButtonPressed: $isButtonPressed,  isSantoFarting: $isSantoFarting, isStefanoFarting: $isStefanoFarting))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Farting is Fun!")
                    .font(Font.custom("Luckiest Guy", size: 36))
                    .foregroundColor(.white)
                    .frame(maxWidth: 150, alignment: .topTrailing)
                    .frame(width: 140, alignment: .trailing)
                    .position(x: 300, y: 46)
                
//                VStack {
//                    Text("\(viewModel.score) pts")
//                        .font(Font.custom("Luckiest Guy", size: 20))
//                        .padding(11)
//                        .padding(.leading, 17)
//                        .background(
//                            RoundedRectangle(cornerRadius: 17)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 17)
//                                        .fill(Color.white)
//                                        .stroke(Color.black, lineWidth: 2)
//                                        .frame(width: 140)
//                                )
//                        )
//                        .position(x: 34, y: -200)
//                    
//                }
                
                Spacer()
                
            }
        }
        .fullScreenCover(isPresented: $isLeaderboardVisible) {
            FartingLeaderboardView(fastestFarters: [5.0, 6.0, 7.0])
        }
        .onAppear {
            // Check if the game is finished (you may need to adjust this condition)
            if isGameOver {
                isLeaderboardVisible = true // Show the leaderboard view when the game is finished
            }
        }
    }
}

struct FartingGameView_Previews: PreviewProvider {
    static var previews: some View {
        FartingGameView(time: .constant(TimeInterval()), currentTime: .constant(TimeInterval()))
    }
}

