import DouShouQiModel
import UIKit
import Foundation

class GameVM: ObservableObject {
    /// Le game
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
    var invalidMoveCallback: (() -> Void)?
    
    init(player1: Player, player2: Player) {
        // definir les joueurs
        self.player1VM = PlayerVM(player: player1)
        self.player2VM = PlayerVM(player: player2)
        self.currentPlayerVM = player1VM
        
        // initialiser un nouveau game
        self.game = try! Game(withRules: ClassicRules(), andPlayer1: player1VM.player, andPlayer2: player2VM.player)
    }
    
    //Listener du callback pour le reset piece dans SpriteMeeple
    func addInvalidMoveCallbacksListener(callback: @escaping () -> Void) {
        self.invalidMoveCallback = callback
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
        self.game.addGameStartedListener { _ in
            print("Game Started")
        }
        
        self.game.addBoardChangedListener { _ in
            print("*** BOARD CHANGED ***")
            print("*** ***** ******* ***")
            // print(self.game.board)
            print()
        }
        
        self.game.addBoardChangedListener {
            print("*** changed 2 ***")
            print($0)
        }
        
        self.game.addPlayerNotifiedListener({ board, player in
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), it's your turn!")
            print("**************************************")
            self.getNextPlayer()
            
            //try! await Persistance.saveGame(withName: "game", andGame: game2)
        })
        
        self.game.addMoveChosenCallbacksListener { _, move, player in
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), has chosen: \(move)")
            print("**************************************")
        }
        
        self.game.addInvalidMoveCallbacksListener { _, move, player, result in
           if result {
             return
           }
           print("**************************************")
           print("⚠️⚠️⚠️⚠️ Invalid Move detected: \(move) by \(player.name) (\(player.id))")
           print("**************************************")
           
            self.invalidMoveCallback?()
            
       }
        try? await game.start()
    }
    
    /// Création des pieces
    func createScenePieces() -> [Owner: [Animal: SpriteMeeple]]{
        var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
        let meepleSize = CGSize(width: 80, height: 80)
        
        let players = [self.player1VM.player, self.player2VM.player]
        
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
                addInvalidMoveCallbacksListener {
                    spriteMeeple.resetPiecePosition()
                }
            }
        }
        return pieces
    }
}
