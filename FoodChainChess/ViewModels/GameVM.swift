import DouShouQiModel
import UIKit
import Foundation

class GameVM: ObservableObject {
    /// La game
    @Published var game: Game
    
    /// Les joueurs
    var player1VM: PlayerVM
    var player2VM: PlayerVM
    
    /// Le joueur en coursVM
    @Published var currentPlayerVM: PlayerVM
    
    /// L'id du joueur en cours
    /// Le changement de cette variable déclanche une mise a jour de l'instance
    /// de currentPlayerVM.
    @Published var currentPlayerId: Owner? {
        didSet {
            updateCurrentPlayerVM()
        }
    }
    
    ///CallBack pour reset piece dans SpriteMeeple
    private var meepleCallbacks: [SpriteMeeple: [String : ()  -> Void] ] = [:]

    init(player1: Player, player2: Player) {
        // definir les joueurs
        self.player1VM = PlayerVM(player: player1)
        self.player2VM = PlayerVM(player: player2)
        self.currentPlayerVM = player1VM
        
        // initialiser un nouveau game
        self.game = try! Game(withRules: ClassicRules(), andPlayer1: player1VM.player, andPlayer2: player2VM.player)
    }
    
    
    //Listener du callback pour le reset piece dans SpriteMeeple
    func addInvalidMoveCallbacksListener(for meeple: SpriteMeeple, callback: @escaping () -> Void) {
        meepleCallbacks[meeple] = ["InvalidMove":callback]
    }
    
    // Gestion des Players //
    func getNextPlayer() {
        self.currentPlayerId = game.rules.getNextPlayer()
    }
    
    /// Mettre a jour le joueur actuelle
    func updateCurrentPlayerVM() {
        print("Updating current player")
        switch self.currentPlayerId {
        case .player1:
            self.currentPlayerVM = self.player1VM
        case .player2:
                self.currentPlayerVM = self.player2VM
        case .noOne:
            break
        case .none:
            break
        case .some(_): // au cas ou des nouvelles valeurs de owners sont ajouté au futur
            break
        }
    }
    
    /// Lancer la boucle de jeu
    func start() async {
        
        try? await game.start()
    }
    
    /// Création des pieces
    func createScenePieces() -> [Owner: [Animal: SpriteMeeple]]{
        var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
        let meepleSize = CGSize(width: 80, height: 80)
        
        let players = [self.player2VM.player, self.player1VM.player]
        
        let animals: [Animal] = [.rat, .cat, .dog, .wolf, .leopard, .tiger, .lion, .elephant]
        
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
