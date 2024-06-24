import DouShouQiModel
import UIKit
import Foundation

class GameVM: ObservableObject {
    /// Le game
    @Published var game: Game?
    
    var playerManager = PlayerManager.shared

    /// Reference a current player VM
    var currenPlayerVM: PlayerVM? {
        return playerManager.currentPlayer
    }
    
    ///CallBack pour reset piece dans SpriteMeeple
    private var meepleCallbacks: [SpriteMeeple: [String : ()  -> Void] ] = [:]

    
    func initGame() {
        self.game = try! Game(
            withRules: playerManager.rules,
            andPlayer1: playerManager.selectedPlayer1.player,
            andPlayer2: playerManager.selectedPlayer2.player
        )
    }
    
    
    //Listener du callback pour le reset piece dans SpriteMeeple
    func addInvalidMoveCallbacksListener(for meeple: SpriteMeeple, callback: @escaping () -> Void) {
        meepleCallbacks[meeple] = ["InvalidMove":callback]
    }
    
    /// Mettre a jour le joueur actuelle
    func updateCurrentPlayerVM(currentPlayerId: Owner) {
        playerManager.updateCurrentPlayer(currentPlayerId: currentPlayerId)
    }
    
    /// Lancer la boucle de jeu
    func start() async {
        try? await game?.start()
    }
    
    /// Création des pieces
    func createScenePieces() -> [Owner: [Animal: SpriteMeeple]]{
        var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
        let meepleSize = CGSize(width: 80, height: 80)
        
        let players = [self.playerManager.selectedPlayer2.player, self.playerManager.selectedPlayer1.player]
        
        let animals: [Animal]
        
        if self.game?.rules is ClassicRules {
            print("Classic Animals")
            animals = [.rat, .cat, .dog, .wolf, .leopard, .tiger, .lion, .elephant]
            SpriteMeeple.offset = CGPoint(x: -300, y: -400)
        }
        else {
            print("Simple Animals")
            animals = [.rat, .cat, .tiger, .lion, .elephant]
            SpriteMeeple.offset = CGPoint(x: -200, y: -200)
        }

        for player in players {
            pieces[player.id] = [:]
            for animal in animals {
                let color: UIColor
                switch player.id {
                case .player1:
                    color = .yellow
                case .player2:
                    color = .red
                default:
                    color = .gray
                }
                let spriteMeeple = SpriteMeeple(imageNamed: "\(animal)", size: meepleSize, backgroundColor: color, owner: player.id)
                
                pieces[player.id]?[animal] = spriteMeeple
                
                //Listener qui va declencher le resetPiecePosition dans SpriteMeeple
                addInvalidMoveCallbacksListener(for: spriteMeeple) {
                    spriteMeeple.resetPiecePosition()
                }
                
            }
        }
        return pieces
    }
    
    func triggerInvalidMoveCallback() {
        for (meeple, callback) in meepleCallbacks {
            print("\(meeple.isCurrentMeeple)")
            if meeple.isCurrentMeeple, let invalidMoveCallback = callback["InvalidMove"] {
                invalidMoveCallback()
                return
            }
        }
    }
}
