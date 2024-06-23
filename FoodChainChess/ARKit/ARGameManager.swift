import Foundation
import SwiftUI
import ARKit
import RealityKit
import DouShouQiModel


class ARGameManager: ObservableObject {
    let game: Game
    let player1 = HumanPlayer(withName: "Bruno", andId: .player1)!
    let player2 = HumanPlayer(withName: "BrunoBis", andId: .player2)!
    
    var pieces: [Owner: [Animal: PieceObject]] = [:]
    
    init() {
        self.game = try! Game(withRules: ClassicRules(), andPlayer1: player1, andPlayer2: player2)
    }
    
    func startGame() async{
        self.game.addGameStartedListener { _ in
            print("Game Started")
        }
        
    }
    
}
