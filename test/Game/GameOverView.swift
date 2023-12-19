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
    
    @FocusState private var christianIsFocused: Bool
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Partita.playedAt, order: .reverse) var allPartiteSalvate: [Partita]
    var gameLogic: LastDroidGameLogic = LastDroidGameLogic.shared
    private let characterLimit = 3

    var bambino = LastDroidGameScene.madonna.finalScore
    @State var christian: String = ""
    var finalscore =  0
    
    
    var body: some View {
        ZStack {
           
            Image("gameover")
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                
                Image("gameovertext")
                    
                    .padding(.bottom, 90)
                Text ("Score: \(gameLogic.currentScore)")
                    .font(.custom("PressStart2P", size: 20))
                    .foregroundStyle(.yellow)
                    .padding()
                
                
                TextField(
                    "Insert your name", text: $christian)
                .focused($christianIsFocused)
                .onChange(of: christian) {
                    newValue in
                    if christian.count > characterLimit {
                        christian = String(christian.prefix(characterLimit))
                    }
                }
                .font(.custom("PressStart2P", size: 10))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .padding()
                
                Button("Save") {
                          saveName()
                        christianIsFocused = false
                           }
                .foregroundStyle(.yellow)
                .font(.custom("PressStart2P", size: 20))
                .padding()
                
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation { self.backToMainMenu() }
                    } label: {
                        Image("backarrow")
                            
                            .font(.custom("PressStart2P", size: 40))
                            .frame(width: 50, height: 50)
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image("replay")
                            .foregroundColor(.yellow)
                            .font(.custom("PressStart2P", size: 40))
                            .frame(width: 50, height: 50)
                    }
                   
                    
                    Spacer()
                }
            }.padding()
            
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
    
}

#Preview {
   GameOverView(currentGameState: .constant(GameState.gameOver))
}
