//
//  testApp.swift
//  test
//
//  Created by Claudio Borrelli on 09/12/23.
//

import SwiftUI
import Foundation
import SwiftData

@main
struct TheLastDroiddApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()

        }.modelContainer(for: [
            Partita.self
        ])
    }
}
