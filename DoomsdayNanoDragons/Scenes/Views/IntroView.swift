//
//  IntroView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit

struct IntroView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)),Color(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 0))]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            .overlay(
                VStack(spacing: 20) {
                    
                    Spacer() // Add spacer to center the buttons vertically

                    Button(action: {
                        // Transition to Game #1 scene
                    }) {
                        Text("TAP 2 FART!")
                            .font(Font.custom("Luckiest Guy", size: 30)) // Set the font
                            .frame(width: 240, height: 72)
                            .padding(10)
                    }
                    .buttonStyle(IntroButtonStyle())
                    .padding(.top, 20)
                    
                    Button(action: {
                        // Transition to Game #2 scene
                    }) {
                        Text("TAP 2 BADGE IN!")
                            .font(Font.custom("Luckiest Guy", size: 30)) // Set the font
                            .frame(width: 280, height: 72)
                            .padding(10)
                    }
                    .buttonStyle(IntroButtonStyle())
                    
                    
                    Button(action: {
                        // Transition to Game #3 scene
                        transitionToGame(sceneClass: CigaretteGameScene.self)
                    }) {
                        Text("TAP 4 A TRICK!")
                            .font(Font.custom("Luckiest Guy", size: 30)) // Set the font
                            .frame(width: 280, height: 72)
                            .padding(10)
                    }
                    .buttonStyle(IntroButtonStyle())
                    
                    Button(action: {
                        // Transition to Game #4 scene
                    }) {
                        Text("TAP 2 RUN!")
                            .font(Font.custom("Luckiest Guy", size: 30)) // Set the font
                            .frame(width: 280, height: 72)
                            .padding(10)
                    }
                    .buttonStyle(IntroButtonStyle())

                    // Add similar buttons for other games

                    Image("TheAcaGame")
                        .resizable()
                        .frame(width: 367, height: 258)
                        .padding(1)
                        

                    Spacer() // Add spacer to center the buttons vertically
                }
            )
    }
}

func transitionToGame(sceneClass: SKScene.Type) {
    let gameScene = sceneClass.init(size: self.size)
    gameScene.scaleMode = .aspectFill
    let skView = SKView(frame: UIScreen.main.bounds)
    skView.presentScene(gameScene)
    UIApplication.shared.windows.first?.rootViewController?.view = skView
}


struct IntroButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Color(#colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)))
            .foregroundColor(.white)
            .border(Color.white, width: 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .padding(2)
    }
}

#Preview {
    IntroView()
}
