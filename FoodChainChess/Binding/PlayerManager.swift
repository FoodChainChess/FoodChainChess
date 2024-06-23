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
    
    @Published var currentPlayer: PlayerVM?
    
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
        
        // Set the first player to current
        self.currentPlayer = selectedPlayer2
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
    
    /// Adjust the selcted players Id's to make sure they are not the same.
    func adjustSelectedPlayersId() {
        guard self.selectedPlayer1.player.id != self.selectedPlayer2.player.id else {
            // For each selected player, find the player in the created player list
            if let index1 = createdPlayers.firstIndex(where: { $0.name == selectedPlayer1.player.name }),
               let index2 = createdPlayers.firstIndex(where: { $0.name == selectedPlayer2.player.name }) {
                
                // Replace its instance with a new player with the same name but proper id
                let newPlayer1 = HumanPlayer(withName: selectedPlayer1.player.name, andId: .player1)
                let newPlayer2 = HumanPlayer(withName: selectedPlayer2.player.name, andId: .player2)
                
                if let newPlayer1 = newPlayer1, let newPlayer2 = newPlayer2 {
                    // Update the createdPlayers list with the new players
                    createdPlayers[index1] = newPlayer1
                    createdPlayers[index2] = newPlayer2
                    
                    // Reassign selectedPlayer1 and selectedPlayer2 holders with the new players
                    self.selectedPlayer1 = PlayerVM(player: newPlayer1)
                    self.selectedPlayer2 = PlayerVM(player: newPlayer2)
                } else {
                    fatalError("Failed to create new player instances.")
                }
            } else {
                fatalError("Selected players not found in the created players list.")
            }
            return
        }
    }
    
    func updateCurrentPlayer(currentPlayerId: Owner) {
        // Ensure currentPlayer is not nil
        guard let currentPlayer = self.currentPlayer else {
            return
        }
        
        if self.currentPlayer?.player.id == currentPlayerId {
            return
        } else { // Switch to the other player
            if currentPlayer.player.id == self.selectedPlayer1.player.id {
                self.currentPlayer = self.selectedPlayer2
            } else {
                self.currentPlayer = self.selectedPlayer1
            }
        }
    }
}
