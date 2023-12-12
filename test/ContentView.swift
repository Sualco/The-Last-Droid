//
//  ContentView.swift
//  test
//
//  Created by Claudio Borrelli on 09/12/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //define a scene
    
    var scene: SKScene {
        let scene = GameScene ()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        return scene
    }
    
    var body: some View {
        VStack {
            SpriteView (scene: scene)
                .frame(width: screenWidth, height: screenHeight)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
