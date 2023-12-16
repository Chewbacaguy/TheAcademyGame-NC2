//
//  FartingGameView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//
// ElevatorGameView.swift

import SwiftUI
import _SpriteKit_SwiftUI

struct ElevatorGameView: View {
    @State private var isAnimationStarted = false
    @State private var isGameOver = false
    @State private var isLeaderboardVisible = false
    @StateObject private var viewModel = ElevatorGameViewModel()

    @State private var backgroundImage: Image?
    @State private var timer: Timer?
    @State private var remainingTime = 15
    @State private var tapCount = 0
    @State private var winningTime: Int?

    var body: some View {
        ZStack {
            if let backgroundImage = backgroundImage {
                backgroundImage
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                SpriteView(scene: ElevatorGameScene(size: UIScreen.main.bounds.size, viewModel: viewModel, isAnimationStarted: $viewModel.isGameRunning, isGameOver: $viewModel.isGameOver))
                    .edgesIgnoringSafeArea(.all)
            }

            VStack {
                Text("Tap to start!")
                    .font(Font.custom("Luckiest Guy", size: 30))
                    .foregroundColor(.white)

                HStack {
                    Text("\(remainingTime)")
                        .font(Font.custom("Luckiest Guy", size: 80))
                        .foregroundColor(.black)

                    Text("sec")
                        .font(Font.custom("Luckiest Guy", size: 19))
                        .foregroundColor(.black)
                        .padding(.leading, 7)
                        .padding(.top, 7)
                }
                .padding(-3)

                Text("Beat the time")
                    .font(Font.custom("Luckiest Guy", size: 20))
                    .foregroundColor(.black)

                ProgressBar(value: tapCount, total: 20)
                    .frame(width: 200, height: 10)
                    .padding(.top, -5)

                Spacer()

                Button(action: {
                    if isGameOver {
                        withAnimation {
                            viewModel.resetGame()
                            isAnimationStarted = false
                            isGameOver = false
                            backgroundImage = nil
                            remainingTime = 15
                            tapCount = 0
                            winningTime = nil
                            timer?.invalidate()
                        }
                    } else {
                        tapCount += 1

                        if !isAnimationStarted {
                            isAnimationStarted = true
                            startTimer()
                        }

                        if tapCount == 20 {
                            winningTime = remainingTime
                            isLeaderboardVisible = true
                        }
                    }
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
            ElevatorLeaderboardView(topCatches: [5, 6, 7], winningTime: winningTime ?? 0)
        }
        .onChange(of: isGameOver) { gameOver in
            if gameOver {
                timer?.invalidate()
            }
        }
        .onChange(of: isAnimationStarted) { _ in
            startTimer()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                isGameOver = true

                if tapCount == 20 {
                    winningTime = remainingTime
                    isLeaderboardVisible = true
                }
            }
        }
    }
}

struct ProgressBar: View {
    var value: Int
    var total: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.2)
                    .foregroundColor(Color.white)

                RoundedRectangle(cornerRadius: 12.0)
                    .frame(width: min(CGFloat(value) / CGFloat(total) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.black)
                    .animation(.linear)
            }
        }
    }
}

struct ElevatorGameView_Previews: PreviewProvider {
    static var previews: some View {
        ElevatorGameView()
    }
}
