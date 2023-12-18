//
//  LeaderboardView.swift
//  test
//
//  Created by Claudio Borrelli on 16/12/23.
//

import SwiftUI
import SpriteKit
import Foundation
import AVFoundation
import SwiftData

struct LeaderboardView: View {

    @Binding var currentGameState: GameState
    

    
    @Environment(\.modelContext) private var context
    @Query(sort: \Partita.playedAt, order: .reverse) var allPartiteSalvate: [Partita]

    var body: some View {
        NavigationView {
            ZStack {
                Image ("background")
                Text ("LeadBoard")
                    .font(.custom("PressStart2P", size: 20))
                    .padding(.bottom,560)
                
                VStack {
                    Section {
                        List {
                            ForEach(allPartiteSalvate) {partita in
                                VStack(alignment: .leading) {
                                    Text(partita.playerName)
                                    Text(partita.playedAt, style: .time)
                                        .font(.caption)
                                    //                        Text(partita.punteggiodasalvare)
                                    Text("Score: \(partita.punteggiodasalvare)")
                                } // v stack
                            }
                        }
                    }
                    
                        Button {
                            withAnimation { self.backToMain() }
                        } label: {
                            Text("BACK")
                                .font(.custom("PressStart2P", size: 20))
                                .bold()
                                .padding(.bottom, 90.0)
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.pink)
                        .cornerRadius(10.0)
            }
            
        }
        }
    }
    
    
    private func backToMain() {
        print("backtomain")
        self.currentGameState = .mainMenu
    }
}

#Preview {
   LeaderboardView(currentGameState: .constant(GameState.leaderboard))
}
