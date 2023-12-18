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
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "hand.tap")
                            .foregroundStyle(.black)
                        Text("Slide to Move")
                            .font(.custom("PressStart2P", size: 20))
                            .foregroundStyle(.yellow)
                    }
                    .padding()
                    Text("Slide left and right to shoot the hideous droids. Don't let them shoot you!").font(.custom("PressStart2P", size: 10))
                        .foregroundStyle(.yellow)
                }
                .padding(.bottom, 100)
                
                
                VStack {
                    HStack {
                        Image(systemName: "divide.circle")
                            .foregroundStyle(.black)
                        Text("Destroy Droids")
                            .font(.custom("PressStart2P", size: 20))
                            .foregroundStyle(.yellow)
                    }
                    .padding()
                    Text("Destroy droids and save the earth shooting them an apple").font(.custom("PressStart2P", size: 10))
                        .foregroundStyle(.yellow)
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
