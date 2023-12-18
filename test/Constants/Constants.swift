//
//  Constants.swift
//  test
//
//  Created by Claudio Borrelli on 16/12/23.
//

import Foundation
import SwiftUI
import SpriteKit

enum GameState {
    case mainMenu
    case playing
    case gameOver
    case leaderboard
    case onboarding
}

typealias Instruction = (icon: String, title: String, description: String)

struct MainScreenProperties {
    static let gameTitle: String = "THE LAST DROIDS" 
    
    static let gameInstructions: [Instruction] = [
        (icon: "hand.tap", title: "Slide to Move", description: "Slide left and right to shoot the hideous droids. Don't let them shoot you!"),
        (icon: "divide.circle", title: "Destroy Droids", description: "Destroy droids and save the earth shooting them an apple")
    ]
    
    
    static let accentColor: Color = Color.accentColor
}

