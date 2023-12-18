//
//  LastDroidGameView.swift
//  test
//
//  Created by Claudio Borrelli on 16/12/23.
//

import SwiftUI
import SpriteKit
import Foundation

struct LastDroidGameView: View {
    
   @StateObject var gameLogic: LastDroidGameLogic =  LastDroidGameLogic.shared

    @Binding var currentGameState: GameState
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    
    var lastdroidGameScene: LastDroidGameScene {
        let scene = LastDroidGameScene()
        
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        
        return scene
    }
    
    
    //FROM HERE ON, INTERFACE SUCKS AND ITS A PORCATA :S
    var body: some View {
        ZStack(alignment: .top) {
            // View that presents the game scene
            SpriteView(scene: self.lastdroidGameScene)
                .frame(width: screenWidth, height: screenHeight)
                .statusBar(hidden: true)
                .ignoresSafeArea()
            
            HStack() {
                /**
                 * UI element showing the current score of the player.
                 * Remove it if your game is not based on scoring points.
                 */
//                GameScoreView(score: $gameLogic.currentScore)
            }
            .padding()
            .padding(.top, 40)
        }
        .onChange(of: gameLogic.isGameOver) { _ in
            if gameLogic.isGameOver {
                
                withAnimation {
                    self.presentGameOverScreen()
                }
            }
        }
        .onAppear {
            gameLogic.restartGame()
        }
    }
    
    
    //FUNCTIONS THAT MUST STAY HERE
    private func presentMainMenu() {
        self.currentGameState = .mainMenu
    }
  
    private func presentGameOverScreen() {
        self.currentGameState = .gameOver
    }
}

#Preview {
    LastDroidGameView(currentGameState: .constant(GameState.playing))
}
