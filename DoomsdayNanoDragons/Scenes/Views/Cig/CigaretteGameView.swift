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
    let timerDuration: TimeInterval = 60 // 60 seconds
        @State private var timeRemaining: TimeInterval = 60

    var body: some View {
        ZStack {
            // Add the SpriteView for your game scene in the background
            SpriteView(scene: CigaretteGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel))
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Text("\(viewModel.score)")
                    .font(Font.custom("Luckiest Guy", size: 80))
                    .position(x: 200, y: 80)
                    .foregroundColor(.white)

                Text("Tap to Catch")
                    .font(Font.custom("Luckiest Guy", size: 30))
                    .position(x: 200, y: 210)
                    .foregroundColor(.white)
                
                // Conditionally render the restart button only when in this view
                if isGameOver {
                    RestartButton()
                        .padding(.bottom, 20)
                    if isGameOver {
                                        RestartButton()
                                            .padding(.bottom, 20)
                                    }
                                    
                                    // Show the timer view at the center top
                                    TimerView(timeRemaining: $timeRemaining)
                                        .frame(width: 200, height: 40)
                                        .padding(.top, 20)
                                }
                            }
                            .onAppear {
                                startTimer()
                            }
                        }
    
    // Extract the restart button as a separate view for reusability
    @ViewBuilder
    

    func startTimer() {
            // Start the timer
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer expired, handle game over logic here if needed
                    // Stop the timer when the countdown reaches zero
                    timer.invalidate()
                }
            }
        }
    
    struct TimerView: View {
            @Binding var timeRemaining: TimeInterval
            
            var body: some View {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 200, height: 40)
                    .foregroundColor(.white)
                    .overlay(
                        Text("\(Int(timeRemaining))")
                            .font(Font.custom("Luckiest Guy", size: 20))
                    )
            }
        }
    }
    func RestartButton() -> some View {
        Button(action: {
            // Handle restart logic
        }) {
            Text("Restart")
                .font(Font.custom("Luckiest Guy", size: 30))
                .frame(width: 200, height: 63)
                .foregroundColor(.white)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(3.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 3.0)
                        .stroke(Color.white, lineWidth: 6.0)
                )
        }
    }
}
#Preview {
    CigaretteGameView()
}
