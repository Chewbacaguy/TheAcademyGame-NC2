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
                
                
                // Extract the restart button as a separate view for reusability
                //@ViewBuilder
                
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

