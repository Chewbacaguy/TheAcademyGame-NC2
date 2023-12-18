//
//  ElevatorLeaderboardView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//

// ElevatorLeaderboardView.swift

import SwiftUI

struct ElevatorLeaderboardView: View {
    var topCatches: [Int]
    var winningTime: Int
    @State private var showIntroView = false

    var body: some View {
        if showIntroView {
           IntroView()
        }
        else{
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 319, height: 236)
                    .foregroundColor(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 6)
                            .frame(width: 319, height: 236)
                            .opacity(1)
                    )
                    .overlay(
                        VStack(spacing: 3) {
                            Text("Punctual Students")
                                .font(Font.custom("Luckiest Guy", size: 32))
                                .frame(width: 500, height: 35)

                            Text("Your Winning Time:")
                                .font(Font.custom("Luckiest Guy", size: 20))
                                .frame(width: 280, height: 20)
                                .padding(.top, -3)

                            HStack {
                                Text("\(winningTime) ")
                                    .font(Font.custom("Luckiest Guy", size: 25))
                                    .foregroundColor(.black)

                                Text("sec")
                                    .font(Font.custom("Luckiest Guy", size: 25))
                                    .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                            }
                            .padding(.bottom, 3)

                            ForEach(0..<topCatches.count, id: \.self) { index in
                                HStack {
                                    Text("\(topCatches[index]) ")
                                        .font(Font.custom("Luckiest Guy", size: 25))
                                        .foregroundColor(.black)

                                    Text("sec")
                                        .font(Font.custom("Luckiest Guy", size: 25))
                                        .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                                }
                                .padding(.bottom, 3)
                            }
                        }
                    )

                Button(action: {
                    // Set the state variable to true to show the IntroView
                    self.showIntroView = true
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
            }
        }
    }
}

struct ElevatorLeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        ElevatorLeaderboardView(topCatches: [4, 5, 6], winningTime: 10)
    }
}
