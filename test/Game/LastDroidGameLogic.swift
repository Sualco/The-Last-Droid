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
    
    //TUTTA LA ROBA QUI COMMENTATA NON CI SERVE PERCHé LA LOGICA L'ABBIAMO NELLA GAME SCENE MA ALCUNE COSE LE HO RICHIAMATE QUINDI DOVREBBERO RESTARE SE NON TROVIAMO IL MODO DI PULIRE IL CODICE
    
    
    static let shared: LastDroidGameLogic = LastDroidGameLogic()
    @Published var currentGameState: GameState = .playing

    
    func setUpGame() {
        
        // TODO: Customize!
        
        self.currentScore = 0
//        self.sessionDuration = 0
        self.isGameOver = false
    }
    
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    
  
    
    func restartGame() {
        
        // TODO: Customize!
        
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
