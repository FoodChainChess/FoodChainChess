import Foundation
import SpriteKit
import SwiftUI
import DouShouQiModel

class GameScene: SKScene {

    let imageBoard: SKSpriteNode = SKSpriteNode(imageNamed: "Board")
        
    var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
    var highlightedNodes: [SKShapeNode] = []
    
    /// Instance de game
    @Published var gameVM: GameVM
    
    /// Permet un access rapide a l'instance de game
    var game: Game {
        return self.gameVM.game
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, player1: Player, player2: Player) {
        self.gameVM = GameVM(player1: player1, player2: player2)
        super.init(size: size)
        
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(imageBoard)
        
        self.pieces = gameVM.createScenePieces()
        
        for piece in pieces.flatMap({ $0.value.values }) {
            self.addChild(piece)
            
            displayBoard(game.board)
            
            showNextPlayerAnimation()
        }
    }

       
    /// Afficher le plateau
    func displayBoard(_ board: Board) {
        for row in 0..<board.nbRows {
            for col in 0..<board.nbColumns {
                if let p = board.grid[row][col].piece, let sprite = pieces[p.owner]?[p.animal] {
                    sprite.cellPosition = CGPoint(x: col, y: row)
                }
            }
        }
    }
    
    /// Souligné les noeuds selon les moves possibles
    func highlightMoves(_ moves: [Move]) {
        clearHighlightedNodes()
        
        let cellWidth = imageBoard.size.width / CGFloat(game.board.nbColumns)
        let cellHeight = imageBoard.size.height / CGFloat(game.board.nbRows)
        
        for move in moves {
            let highlight = SKShapeNode(circleOfRadius: cellWidth / 4)
            highlight.fillColor = .green
            highlight.strokeColor = .clear
            
            let xPosition = CGFloat(move.columnDestination) * cellWidth - imageBoard.size.width / 2 + cellWidth / 2
            let yPosition = CGFloat(move.rowDestination) * cellHeight - imageBoard.size.height / 2 + cellHeight / 2
            highlight.position = CGPoint(x: xPosition, y: yPosition)
            
            self.addChild(highlight)
            highlightedNodes.append(highlight)
        }
        
        self.view?.setNeedsDisplay()
    }
    
    /// Effacer les noeuds soulignées
    func clearHighlightedNodes() {
        for node in highlightedNodes {
            node.removeFromParent()
        }
        highlightedNodes.removeAll()
    }
    /// Affiche une animation indiquant le prochain tour
    func showNextPlayerAnimation() {
        // Obtenez le prochain joueur en utilisant les règles du jeu
        let nextPlayer = game.rules.getNextPlayer()
        
        // Créez un nœud de texte pour afficher le prochain joueur
        let nextPlayerLabel = SKLabelNode(text: "Next Player : \(String(describing: nextPlayer))")
        nextPlayerLabel.fontSize = 40
        nextPlayerLabel.fontColor = .white
        nextPlayerLabel.position = CGPoint(x: 0, y: 0)
        nextPlayerLabel.alpha = 0
        nextPlayerLabel.zPosition = 1
        
        // Ajoutez le nœud de texte à la scène
        self.addChild(nextPlayerLabel)
        
        // Animation pour faire apparaître puis disparaître le nœud de texte
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
        
        nextPlayerLabel.run(sequence)
    }
}
