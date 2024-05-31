//
//  PlayerManager.swift
//  FoodChainChess
//
//  Created by étudiant on 28/05/2024.
//

import Foundation
import DouShouQiModel

/// The player manager class.
class PlayerManager : ObservableObject {
    @Published var createdPlayers: [Player] = []
    
    /// Adds a new player to the list.
    ///
    /// -parameter username: the user's name
    func addPlayer(username: String) {
        let newPlayer = Player(withName: username, andId: .player1)
        
        if let newPlayer {
            createdPlayers.append(newPlayer)
        } else {
            print("New player instance failed.")
        }
    }
}
