//
//  IntroView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit

struct IntroView: View {
    
    @State private var isCigaretteGameActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)),Color(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 0))]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 20) {
                            
                            Spacer() // Add spacer to center the buttons vertically
                            
                            NavigationLink(destination: FartingGameView()) {
                                Text("TAP 2 FART!")
                                    .font(Font.custom("Luckiest Guy", size: 30))
                                    .frame(width: 280, height: 72)
                                    .padding(10)
                            }
                            .buttonStyle(IntroButtonStyle())
                            .padding(.top, 20)
                            
                            NavigationLink(destination: ElevatorGameView()) {
                                Text("TAP 2 BADGE IN!")
                                    .font(Font.custom("Luckiest Guy", size: 30))
                                    .frame(width: 280, height: 72)
                                    .padding(10)
                            }
                            .buttonStyle(IntroButtonStyle())
                            
                            NavigationLink(destination: CigaretteGameView()) {
                                Text("TAP 4 A TRICK!")
                                    .font(Font.custom("Luckiest Guy", size: 30))
                                    .frame(width: 280, height: 72)
                                    .padding(10)
                            }
                            .buttonStyle(IntroButtonStyle())
                            
                            NavigationLink(destination: RunningGameView()) {
                                Text("TAP 2 RUN!")
                                    .font(Font.custom("Luckiest Guy", size: 30))
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
    }
}




struct IntroButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 240, height: 72)
            .background(configuration.isPressed ? Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) : Color(#colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)))
            .foregroundColor(.white)
            .cornerRadius(3.0)
            .overlay(configuration.isPressed ? RoundedRectangle(cornerRadius: 3.0)
                .stroke(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), lineWidth: 5) : RoundedRectangle(cornerRadius: 3.0)
                .stroke(Color.white, lineWidth: 5))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


#Preview {
    IntroView()
}
