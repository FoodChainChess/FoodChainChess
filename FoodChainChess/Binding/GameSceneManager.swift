//
//  GameSceneManager.swift
//  FoodChainChess
//
//  Created by étudiant on 22/06/2024.
//

import Foundation

/// Singleton holder for game scene.
class GameSceneManager: ObservableObject {    
    let gameScene: GameScene

    init() {
        self.gameScene = GameScene(size: CGSize(width: 700, height: 900))
    }
}
