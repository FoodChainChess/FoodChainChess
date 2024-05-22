//Exemple donné en CM de Marc

import Foundation
import SpriteKit
import DouShouQiModel

class GameScene : SKScene{
    
    var game: Game = Game(withRules : ClassicRules(), andPlayer1 : RandomPlayer(withName: "toto", andId...))
    
    let pieces: [Owner : [Animal.SpriteMeeple]]...
    
    let imageBoard : SKSpriteNode =
        SKSpriteNode(imageNamed: "board")
    let meepleSize = CGSize(width: 80, height: 100)
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .red
        
        self.addChild(imageBoard)
        
        
        var ratMeeple = SpritMeeple(imageNamed : "ratMeeple", size: meepleSize, backgroundColor: .yellow)
        ratMeeple.cellPosition = CGPoint(x: 1, y: 1)
        //ratMeeple.position = CGPoint(x: -400, y: -200)
        
        self.addChild(ratMeeple)
        
        for piece in pieces.flatMap( {owner, pieces in
            pieces.values
        }) {
            self.addChild(piece)
        }
        
        displayBoard(board)
    }
    
    func displayBoard(_ board: Board ) {
        for row in 0..<board.nbColumns {
            if let p = board.grid[row][col].piece {
                pieces[p.owner][p.animal] {
                    sprite.cellPosition = CGPoint(x: row, y: col)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
