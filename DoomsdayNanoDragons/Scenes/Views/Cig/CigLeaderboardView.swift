//
//  CigLeaderboardView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI

struct CigLeaderboardView: View {
    var topCatches: [Int] // Replace this with your actual leaderboard data
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 319, height: 236)
                .foregroundColor(Color.white)
                .overlay(
                    VStack(spacing: 10) {
                        Text("THE CHIMNEYS")
                            .font(.system(size: 30))
                        
                        Text("Top Catches")
                            .font(.system(size: 14))
                        
                        ForEach(0..<topCatches.count, id: \.self) { index in
                            Text("\(topCatches[index]) catches")
                                .font(.system(size: 25))
                                .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                        }
                        
                        Button(action: {
                            // Handle exit button click
                        }) {
                            Text("EXIT")
                                .font(.system(size: 20))
                                .foregroundColor(Color(#colorLiteral(red: 0.72, green: 0, blue: 0, alpha: 1)))
                                .frame(width: 138.77, height: 45)
                                .background(Color.white)
                                .cornerRadius(3.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.black, lineWidth: 5)
                                )
                                .shadow(color: .black, radius: 5, x: 4, y: 5)
                        }
                    }
                )
        }
    }
}


#Preview {
    CigLeaderboardView(topCatches: [3,5,6])
}
