//
//  LastDroidGameLogic.swift
//  test
//
//  Created by Claudio Borrelli on 16/12/23.
//

import Foundation
import SpriteKit
import SwiftUI

class LastDroidGameLogic: ObservableObject {

    static let shared: LastDroidGameLogic = LastDroidGameLogic()
    @Published var currentGameState: GameState = .playing

    
    func setUpGame() {
        self.currentScore = 0
        self.isGameOver = false
    }
    
    // Keeps track of the current score to save the var score and pass it in the model
    @Published var currentScore: Int = 0
    
    func restartGame() {
        self.setUpGame()
    }
    
    // Game Over Conditions
    @Published var isGameOver: Bool = false
    
    func finishGame() { //finishTheGame
        if self.isGameOver == false {
            self.isGameOver = true
        }
    }
    
}
