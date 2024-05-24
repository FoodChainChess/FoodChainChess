import Foundation
import SpriteKit
import DouShouQiModel

class GameScene : SKScene{
    
    let imageBoard : SKSpriteNode =
        SKSpriteNode(imageNamed: "Board")
    let meepleSize = CGSize(width: 80, height: 80)
    
    var game: Game?
    var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .red
        
        self.addChild(imageBoard)
                
        self.pieces = [
            .player1: [.rat: SpriteMeeple(imageNamed: "rat", size: meepleSize, backgroundColor: .yellow)],
            .player2: [.rat: SpriteMeeple(imageNamed: "rat", size: meepleSize, backgroundColor: .red)]
        ]
        
        for piece in pieces.flatMap( {owner, pieces in
            pieces.values
        }) {
            self.addChild(piece)
        }
        
        do {
            self.game = try Game(withRules: ClassicRules(), andPlayer1: HumanPlayer(withName: "Human", andId: .player1)!, andPlayer2: RandomPlayer(withName: "Random", andId: .player2)!)
            displayBoard(game!.board)
        } catch {
            print("Failed to initialize game: \(error)")
        }
        
        displayBoard(game!.board)
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
        super.init(coder: aDecoder)
    }
}
