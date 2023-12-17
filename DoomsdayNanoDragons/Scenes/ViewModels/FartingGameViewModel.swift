//
//  FartingGameViewModel.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//

import Foundation

class FartingGameViewModel: ObservableObject {
    @Published var score = 0
    @Published var isGameRunning = false
    @Published var isGameOver = false
    @Published var currentFrame = 0
    @Published var vasillyTurnCount = 0
    @Published var lastUpdateTime: TimeInterval = 0
    @Published var timeRemaining = 60

    
    var vasiliThinking = true
    var vasiliLooking = false
    var vasiliAngry = false

    
    func incrementVasillyTurnCount() {
        vasillyTurnCount += 1
    }
    
    // Function to increment the score
    func incrementScore() {
        score += 1
    }

    // Function to decrement the score by a specified value
    func decrementScoreBy(_ value: Int) {
        score -= value
        if score < 0 {
            score = 0
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
        vasillyTurnCount = 0
        vasiliThinking = true
        vasiliLooking = false
        vasiliAngry = false
    }

    // Function to start the game
    func startGame() {
        resetGame()
        isGameRunning = true
    }
    
}

