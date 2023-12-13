//
//  FartingLeaderBoardView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//

import SwiftUI
import SpriteKit
import SwiftUI

struct FartingLeaderboardView: View {
    var topCatches: [Int] // Replace this with your actual leaderboard data
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 319, height: 236)
                .foregroundColor(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20) // Add another RoundedRectangle as an overlay
                        .stroke(Color.black, lineWidth: 6) // Add a border stroke with rounded corners
                        .frame(width: 319, height: 236) // Match the size of the rounded rectangle
                        .opacity(1) // Adjust the opacity as needed
                )
                .overlay(
                    VStack(spacing: 3) {
                        Text("LOS ARMA PEDOS")
                            .font(Font.custom("Luckiest Guy", size: 36))
                            .frame(width: 290, height: 35)
                        
                        Text("Smoothest Criminal times")
                            .font(Font.custom("Luckiest Guy", size: 16))
                            .frame(width: 280, height: 20)
                            .padding(.top, -3)
                        
                        // NEEDS LOGIC FOR BEST TIMES, not top catches
                        ForEach(0..<topCatches.count, id: \.self) { index in
                            HStack {
                                Text("\(topCatches[index]) ")
                                    .font(Font.custom("Luckiest Guy", size: 25))
                                    .foregroundColor(.black)
                                
                                Text("sec")
                                    .font(Font.custom("Luckiest Guy", size: 25))
                                    .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                            }
                            .padding(.bottom, 3) // Move this line inside HStack
                        }
                    }
                )
            
            Button(action: {
                // Handle exit button click
                // NAVIGATE BACK TO CONTENTVIEW
            }) {
                Text("EXIT")
                    .font(Font.custom("Luckiest Guy", size: 30)) // Adjust the font size
                    .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 138.77, height: 53) // Adjust the frame size
                    .background(Color.white)
                    .cornerRadius(3.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.black, lineWidth: 6) // Add a border stroke
                    )
                    .padding(.top, -25) // Add top padding
            }
        }
    }
}


struct FartingLeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        FartingLeaderboardView(topCatches: [4,5,6])
    }
}
