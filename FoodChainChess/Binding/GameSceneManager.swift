//
//  GameSceneManager.swift
//  FoodChainChess
//
//  Created by étudiant on 13/06/2024.
//

import Foundation

class GameSceneManager: ObservableObject {
    
    /// Global instance of current move
    @Published var gameScene: GameScene?
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
}
