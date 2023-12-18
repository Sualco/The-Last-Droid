//
//  GameOverView.swift
//  test
//
//  Created by Claudio Borrelli on 16/12/23.
//

import SwiftUI
import SpriteKit
import Foundation
import AVFoundation
import SwiftData



struct GameOverView: View {
    @Binding var currentGameState: GameState
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Partita.playedAt, order: .reverse) var allPartiteSalvate: [Partita]
    var gameLogic: LastDroidGameLogic = LastDroidGameLogic.shared

    var bambino = LastDroidGameScene.madonna.finalScore
    @State var christian: String = ""
    var finalscore =  0
    
    var body: some View {
        ZStack {
            Image("gameover")
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                Text("GAME OVER")
                    .font(.custom("PressStart2P", size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.bottom, 90)
                
                TextField(
                    "insert your name",
                    text: $christian
                    
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .padding()
                
                Button("Save") {
                          saveName()
                           }
                .foregroundStyle(.yellow)
                .font(.custom("PressStart2P", size: 20))
                
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation { self.backToMainMenu() }
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.yellow)
                            .font(.custom("PressStart2P", size: 40))
                            .frame(width: 50, height: 50)
                    }
                    //.background(Rectangle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 50, height: 50, alignment: .bottom))
                    
                    Spacer()
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.yellow)
                            .font(.custom("PressStart2P", size: 40))
                            .frame(width: 50, height: 50)
                    }
                   
                    
                    Spacer()
                }
            }
            
        }
        .statusBar(hidden: true)
    }
    
    //FUNCTIONS
    
//    private func saveName() {
//          if !name.isEmpty {
//              var playerNames = UserDefaults.standard.stringArray(forKey: "playerNames") ?? []
//              playerNames.append(name)
//              UserDefaults.standard.set(playerNames, forKey: "playerNames")
//              name = ""
//              print("Name saved")
//          }
//      }
    
    
    func saveName() {
        let note = Partita(id: UUID().uuidString, playerName: christian, playedAt: .now, punteggiodasalvare: gameLogic.currentScore)
            context.insert(note)
        
            try? context.save()
    
        
        
        }
    
    
    
    private func backToMainMenu() {
        self.currentGameState = .mainMenu
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
    
//  @State private var savingScore = LastDroidGameScene()
//    private func saveScore() {
//          if !name.isEmpty {
//              var playerNames = UserDefaults.standard.stringArray(forKey: "playerNames") ?? []
//              playerNames.append(name)
//              UserDefaults.standard.set(playerNames, forKey: "playerNames")
//              name = ""
//              print("Name saved")
//          }
//      }
//
//
}

#Preview {
   GameOverView(currentGameState: .constant(GameState.gameOver))
}
