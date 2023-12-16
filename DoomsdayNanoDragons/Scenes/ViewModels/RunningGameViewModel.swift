//
//  RunningGameViewModel.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//

import Foundation

class RunningGameViewModel: ObservableObject {
    @Published var score = 0
    @Published var isGameRunning = false
    @Published var isGameOver = false
    @Published var currentFrame = 0
    
    
    // Function to increment the score
    func incrementScore() {
        score += 1
    }

    // Function to decrement the score by a specified value
    func decrementScoreBy(_ value: Int) {
        score -= value
        if score < 0 {
            score = 0 // Ensure the score doesn't go negative
        }
    }

    // Function to increment the score by a specified value
    func incrementScoreBy(_ value: Int) {
        score += value
    }

    // Function to reset the game
    func resetGame() {
        score = 0
        isGameRunning = false
        currentFrame = 0
    }
}


