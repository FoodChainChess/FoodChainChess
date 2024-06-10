import DouShouQiModel
import Foundation

class GameVM: ObservableObject {
    var game: Game
    var player1VM: PlayerVM
    var player2VM: PlayerVM
    @Published var currentPlayerVM: PlayerVM
    
    @Published var currentPlayer: Owner? {
        didSet {
            updateCurrentPlayerVM()
        }
    }
    
    init(player1: Player, player2: Player) {
        self.player1VM = PlayerVM(player: player1)
        self.player2VM = PlayerVM(player: player2)
        self.currentPlayerVM = player1VM
        
        self.game = try! Game(withRules: ClassicRules(), andPlayer1: player1VM.player, andPlayer2: player2VM.player)
        
        do {
            // TODO: adjust player initialization
            self.game = try Game(withRules: ClassicRules(), andPlayer1: HumanPlayer(withName: "Human", andId: .player1)!, andPlayer2: RandomPlayer(withName: "Random", andId: .player2)!)
        } catch {
            fatalError("failed to create game: \(error)")
        }
    }
    
    // Gestion des Players //
    func getNextPlayer() {
        self.currentPlayer = game.rules.getNextPlayer()
    }
    
    func updateCurrentPlayerVM() {
        print("Updating current player")
        switch self.currentPlayer {
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
    
    func start() async {
        print("GAME STARTED")
       //  self.getNextPlayer()
        try? await game.start()
    }
}
