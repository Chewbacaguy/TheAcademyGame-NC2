//
//  CigLeaderboardView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import SpriteKit

struct CigLeaderboardView: View {
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
                        Text("THE CHIMNEYS")
                            .font(Font.custom("Luckiest Guy", size: 42))
                            .frame(width: 280, height: 35)
                        
                        Text("Top Catches")
                            .font(Font.custom("Luckiest Guy", size: 18))
                            .frame(width: 280, height: 20)
                            .padding(.top, -3)
                        
                        ForEach(0..<topCatches.count, id: \.self) { index in
                            HStack{
                                Text("\(topCatches[index]) ")
                                    .font(Font.custom("Luckiest Guy", size: 25))
                                    .foregroundColor(.black)
                                
                                Text("catches")
                                    .font(Font.custom("Luckiest Guy", size: 25))
                                    .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                            }
                            .padding(.bottom, 3) // Move this line inside HStack
                        }
                    }
                )
              
        }
    }
}



struct CigLeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        CigLeaderboardView(topCatches: [3, 5, 6])
    }
}
