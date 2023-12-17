//
//  CigaretteGameViewModel.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 12/12/23.
//

import SwiftUI
import Combine

class CigaretteGameViewModel: ObservableObject {
    @Published var score = 0
    @Published var isGameRunning = false
    @Published var isGameOver = false
    @Published var currentFrame = 0
    @Published var topCatches: [Int] = [] // Define topCatches as @Published property
    
    
    func incrementScore() {
        score += 1
    }
    
    func resetGame() {
        score = 0
        isGameRunning = false
        currentFrame = 0
    }
    
    
    func incrementScore(by value: Int) {
           score += value
       }
}
