import Foundation
import SpriteKit
import SwiftUI
import DouShouQiModel

class GameScene: SKScene {

    let imageBoard: SKSpriteNode = SKSpriteNode(imageNamed: "Board")
    let meepleSize = CGSize(width: 80, height: 80)
    
    var game: Game
    @ObservedObject var player1: PlayerVM
    @ObservedObject var player2: PlayerVM
    
    var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
    var highlightedNodes: [SKShapeNode] = []
    
    var currentPlayer: Owner?
    
    init(size: CGSize, player1: PlayerVM, player2: PlayerVM) {
        self.player1 = player1
        self.player2 = player2
        self.game = try! Game(withRules: ClassicRules(), andPlayer1: player1.player, andPlayer2: player2.player)
        super.init(size: size)
        
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(imageBoard)
        
        let players = [player1.player, player2.player]
        let animals: [Animal] = [.rat, .cat, .dog, .wolf, .leopard, .tiger, .lion, .elephant]
        
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
                let spriteMeeple = SpriteMeeple(imageNamed: "\(animal)", size: meepleSize, backgroundColor: color, owner: player.id)
                self.pieces[player.id]?[animal] = spriteMeeple
            }
        }
        
        for piece in pieces.flatMap({ $0.value.values }) {
            self.addChild(piece)
        }
        
        do {
            self.game = try Game(withRules: ClassicRules(), andPlayer1: HumanPlayer(withName: "Human", andId: .player1)!, andPlayer2: RandomPlayer(withName: "Random", andId: .player2)!)
            displayBoard(game.board)
        } catch {
            print("Failed to initialize game: \(error)")
        }
        
        displayBoard(game.board)
        
        updateCurrentPlayer()
        showNextPlayerAnimation()
    }
    
    func displayBoard(_ board: Board) {
        for row in 0..<board.nbRows {
            for col in 0..<board.nbColumns {
                if let p = board.grid[row][col].piece, let sprite = pieces[p.owner]?[p.animal] {
                    sprite.cellPosition = CGPoint(x: col, y: row)
                }
            }
        }
    }
    
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
    
    func clearHighlightedNodes() {
        for node in highlightedNodes {
            node.removeFromParent()
        }
        highlightedNodes.removeAll()
    }

    func playerChooseMove(for piece: Piece, with possibleMoves: [Move]) -> Move? {
        guard let currentPlayer = currentPlayer else {
            return nil
        }

        let players = [player1.player, player2.player]

        guard let actualPlayer = players.first(where: { $0.id == currentPlayer }) else {
            return nil
        }

        let chosenMove: Move?
        
        if actualPlayer is HumanPlayer {
            return nil
        } else if actualPlayer is RandomPlayer {
            chosenMove = chooseRandomMove(in: possibleMoves)
        } else {
            return nil
        }
        return chosenMove
    }
    
    func chooseRandomMove(in possibleMoves: [Move]) -> Move? {
        guard let move = possibleMoves.randomElement() else {
            return nil
        }
        return move
    }
    
    func applyMove(_ move: Move) {
        //game.rules.playedMove(move, onStartingBoard: game.board, andResultingBoard: game.board)
        displayBoard(game.board)
        updateCurrentPlayer()
        showNextPlayerAnimation()
        print("TUT")
    }
    
    func updateCurrentPlayer() {
        currentPlayer = game.rules.getNextPlayer()
        let players = [player1.player, player2.player]
        if let player = players.first(where: { $0.id == currentPlayer }), player is RandomPlayer {
            let possibleMoves = game.rules.getMoves(in: game.board, of: currentPlayer!)
            let randomMove = chooseRandomMove(in: possibleMoves)
            if let move = randomMove {
                applyMove(move)
            }
        }
    }
    
    func showNextPlayerAnimation() {
        // Obtenez le prochain joueur en utilisant les règles du jeu
        let nextPlayer = currentPlayer
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
