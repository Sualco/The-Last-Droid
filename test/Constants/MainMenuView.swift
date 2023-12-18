//
//  MainMenuView.swift
//  test
//
//  Created by Claudio Borrelli on 16/12/23.
//

import SwiftUI
import Foundation


struct MainMenuView: View {

    @Binding var currentGameState: GameState
    var body: some View {


        ZStack {
            Image("BackgroundDroids")
                .resizable()
                .ignoresSafeArea()

            VStack{
                Spacer()
                //PLAY BUTTON
                Button {
                    withAnimation { self.startGame() }
                } label: {
                    Image("KILL THE DROIDS")
                        .padding()
                        .frame(maxWidth: .infinity)
                }

                //LEADERBOARD BUTTON
                Button {
                    withAnimation { self.openLeaderboard() }
                } label: {
                    Image("LEADERBOARD")
                        .padding(.trailing, 80.0)
                        .padding()

                }

                //INSTRUCTIONS BUTTON
                Button {
                    withAnimation { self.openOnboarding() }
                } label: {
                    Image("INSTRUCTIONS")
                        .padding(.trailing, 60.0)
                        .padding()
                }
                .foregroundColor(.black)
                .cornerRadius(10.0)
            } // end of view!!!

            .padding(.bottom, 120.0)
            .statusBar(hidden: true)
        }

    }


    //FUNCTIONS CALLED IN THE BUTTONS
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
    }

    private func openLeaderboard() {
        print("opening leaderboard")
        self.currentGameState = .leaderboard
    }


    private func openOnboarding() {
        print("opening ob")
        self.currentGameState = .onboarding
    }


}


#Preview {
    MainMenuView(currentGameState: .constant(GameState.mainMenu))
}
