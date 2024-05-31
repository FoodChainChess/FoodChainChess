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
        /// - Parameter username: the user's name
        /// - Returns: An optional error message if the username is invalid or already exists.
        func addPlayer(username: String) -> String? {
            guard !username.isEmpty else {
                return "Username cannot be empty."
            }
            
            guard !createdPlayers.contains(where: { $0.name == username }) else {
                return "Username already exists."
            }
            
            let newPlayer = Player(withName: username, andId: .player1)
            
            if let newPlayer {
                createdPlayers.append(newPlayer)
                return nil
            } else {
                return "Failed to create new player instance"
            }
        }
}
