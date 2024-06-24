//
//  GameSceneManager.swift
//  FoodChainChess
//
//  Created by étudiant on 22/06/2024.
//

import Foundation
import SwiftUI
import DouShouQiModel

/// Singleton holder for game scene.
class GameSceneManager: ObservableObject {    
    var gameScene: GameScene
    @Published var isGameEnded: Bool = false
    @Published var gameWinner: Owner = .noOne

    init() {
        self.gameScene = GameScene(size: CGSize(width: 700, height: 900))
    }
}
