import Foundation
import SpriteKit
import DouShouQiModel

class GameScene : SKScene{
    
    let imageBoard : SKSpriteNode =
    SKSpriteNode(imageNamed: "Board")
    let meepleSize = CGSize(width: 80, height: 80)
    
    var game: Game
    let player1: Player = Player(withName: "Lou", andId: .player1)!
    let player2: Player = Player(withName: "LouBis", andId: .player2)!
    
    var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
    
    override init(size: CGSize) {
        let players = [player1, player2]
        let animals: [Animal] = [.rat, .cat, .dog, .wolf, .leopard, .tiger, .lion, .elephant]
        self.game = try! Game(withRules: ClassicRules(), andPlayer1: self.player1, andPlayer2: self.player2)
        super.init(size: size)
        
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(imageBoard)
        
        for player in players {
            self.pieces[player.id] = [:]
            for animal in animals {
                let color: UIColor
                switch player.id {
                case .player1:
                    color = .red
                case .player2:
                    color = .yellow
                default:
                    color = .gray
                }
                self.pieces[player.id]?[animal] = SpriteMeeple(imageNamed: "\(animal)", size: meepleSize, backgroundColor: color)
            }
        }
            
        print(pieces)
        
        for piece in pieces.flatMap( {owner, pieces in
            pieces.values
        }) {
            self.addChild(piece)
        }
        
        do {
            self.game = try Game(withRules: ClassicRules(), andPlayer1: HumanPlayer(withName: "Human", andId: .player1)!, andPlayer2: RandomPlayer(withName: "Random", andId: .player2)!)
            displayBoard(game.board)
        } catch {
            print("Failed to initialize game: \(error)")
        }
        
        displayBoard(game.board)
    }
    
    func displayBoard(_ board: Board ) {
        for row in 0..<board.nbRows {
            for col in 0..<board.nbColumns {
                if let p = board.grid[row][col].piece, let sprite = pieces[p.owner]?[p.animal] {
                    sprite.cellPosition = CGPoint(x: row, y: col)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.game = try! Game(withRules: ClassicRules(), andPlayer1: self.player1, andPlayer2: self.player2)
        super.init(coder: aDecoder)
    }
}
