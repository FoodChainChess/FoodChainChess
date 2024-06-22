//
//  PlayerManager.swift
//  FoodChainChess
//
//  Created by étudiant on 28/05/2024.
//

import Foundation
import DouShouQiModel

/// The player manager class.
class PlayerManager: ObservableObject {
    @Published var createdPlayers: [Player]
    
    @Published var selectedPlayer1: PlayerVM
    @Published var selectedPlayer2: PlayerVM
    
    static let shared = PlayerManager()

    private init() {
        // Default players
        guard let player1 = HumanPlayer(withName: "Player 1", andId: .player1),
              let player2 = HumanPlayer(withName: "Player 2", andId: .player2) else {
            fatalError("Failed to create default players.")
        }

        // Add defaults to list
        self.createdPlayers = [player1, player2]

        // Set default selected players
        self.selectedPlayer1 = PlayerVM(player: player1)
        self.selectedPlayer2 = PlayerVM(player: player2)
    }
    
    /// Adds a new player to the list.
    ///
    /// - Parameter username: the user's name
    /// - Returns: An optional error message if the username is invalid or already exists.
    func addNewPlayer(username: String, identifier: Owner = .player1) -> String? {
        guard !username.isEmpty else {
            return "Username cannot be empty."
        }
        
        guard !createdPlayers.contains(where: { $0.name == username }) else {
            return "Username already exists."
        }
        
        let newPlayer = HumanPlayer(withName: username, andId: identifier)
        
        if let newPlayer {
            createdPlayers.append(newPlayer)
            return nil
        } else {
            return "Failed to create new player instance"
        }
    }
    
    /// Returns a player instance by username.
    ///
    /// - Parameter username: The username of the player.
    /// - Returns: An optional `Player` instance if found.
    func getPlayerByUsername(_ username: String) -> Player? {
        return createdPlayers.first { $0.name == username }
    }
}
