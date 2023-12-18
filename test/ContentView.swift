//
//  ContentView.swift
//  test
//
//  Created by Claudio Borrelli on 09/12/23.
//



import SwiftUI
import SpriteKit
import Foundation
import AVFoundation

struct ContentView: View {

    @State var currentGameState: GameState = .mainMenu
    @StateObject var gameLogic: LastDroidGameLogic = LastDroidGameLogic()
   //let screenWidth = UIScreen.main.bounds.width
    //let screenHeight = UIScreen.main.bounds.height
    
    
    var scene: SKScene {
        let scene = LastDroidGameScene ()
        //scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        return scene
    }
    
    var body: some View {
            
            switch currentGameState {
            case .mainMenu:
                MainMenuView(currentGameState: $currentGameState)
                    .environmentObject(gameLogic)
            
            case .playing:
                LastDroidGameView(currentGameState: $currentGameState)
                    .environmentObject(gameLogic)
            
            case .gameOver:
                GameOverView(currentGameState: $currentGameState)
                    .environmentObject(gameLogic)
                
                
            case .leaderboard:
                LeaderboardView(currentGameState: $currentGameState)
                    .environmentObject(gameLogic)
           
            case .onboarding:
                OnboardingView(currentGameState: $currentGameState)
                    .environmentObject(gameLogic)
                
            }
        }
    }


#Preview {
    ContentView()
}
