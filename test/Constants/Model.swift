//
//  Model.swift
//  test
//
//  Created by Claudio Borrelli on 17/12/23.
//

import Foundation
import SwiftData


@Model
class Partita {
        
    @Attribute(.unique) var id: String
    var playerName: String
    var playedAt: Date
    var punteggiodasalvare: Int
    
    init(id: String, playerName: String, playedAt: Date, punteggiodasalvare: Int) {
        self.id = id
        self.playerName = playerName
        self.playedAt = playedAt
        self.punteggiodasalvare = punteggiodasalvare
    }
}
