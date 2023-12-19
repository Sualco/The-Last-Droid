//
//  OnBoardingView.swift
//  test
//
//  Created by Claudio Borrelli on 17/12/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var currentGameState: GameState
    
    var gameTitle: String = MainScreenProperties.gameTitle
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    let accentColor: Color = MainScreenProperties.accentColor

    var body: some View {
        ZStack {
            Image("gameover")
                .resizable()
                .ignoresSafeArea()
            VStack {
                VStack {
                    HStack {
                        
                        Text("SLIDE TO MOVE")
                            .font(.custom("PressStart2P", size: 18))
                            .foregroundStyle(.yellow)
                    }
                    .padding()
                    Text("Slide left and right to shoot the hideous droids. Don't let them shoot you!").font(.custom("PressStart2P", size: 12))
                        .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.yellow)
                        .padding()
                }
                .padding(.bottom, 100)
                
                
                VStack {
                    HStack {
                        
                        Text("DESTROY DROIDS")
                            .font(.custom("PressStart2P", size: 18))
                            .foregroundStyle(.yellow)
                    }
                    .padding()
                    Text("Destroy the droids and save the earth shooting them an apple.").font(.custom("PressStart2P", size: 12))
                        .foregroundStyle(.yellow)
                        .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                        .padding()
                    Button {
                        withAnimation { self.backToMain() }
                    } label: {
                        Text("BACK")
                            .font(.custom("PressStart2P", size: 20))
                            .padding()
                        
                    }
                    .foregroundColor(.red)
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
    OnboardingView(currentGameState: .constant(GameState.onboarding))
}
