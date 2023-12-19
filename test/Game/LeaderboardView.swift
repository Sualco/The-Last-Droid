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
    @Query(sort: \Partita.punteggiodasalvare, order: .reverse) var allPartiteSalvate: [Partita]
    
    @State var range: Range<Int> = 0..<3


    var body: some View {
        NavigationView {
            ZStack {
                Image ("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack{
                    Text ("Leaderboard")
                        .font(.custom("PressStart2P", size: 25))
                        .foregroundStyle(.black)
                        .padding()
                    
                    Spacer ()
                    List {
                        ForEach(allPartiteSalvate.prefix(10)) {partita in
                            HStack() {
                                Text(partita.playerName)
                                    .font(.custom("PressStart2P",size: 15))
                                    .background(Color.clear)
                                Spacer()
                                
                                //                                    Text(partita.playedAt, style: .time)
                                //                                        .font(.caption)
                                //                        Text(partita.punteggiodasalvare)
                                Text("Score: \(partita.punteggiodasalvare)")
                                    .font(.custom("PressStart2P",size: 15))
                                    .background(Color.clear)
                                
                            }
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal,20)
                    .background(Color.clear)
                    Spacer()
                    
                    
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
                .padding(.top,150)
            
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
