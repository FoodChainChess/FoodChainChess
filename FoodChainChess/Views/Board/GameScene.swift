import Foundation
import SpriteKit
import SwiftUI
import DouShouQiModel

class GameScene: SKScene, ObservableObject {

    let imageBoard: SKSpriteNode = SKSpriteNode(imageNamed: "Board")
        
    var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
    var highlightedNodes: [SKShapeNode] = []
    
    /// Instance de game vm
    @Published var gameVM: GameVM
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        self.gameVM = GameVM()
        super.init(size: size)
        
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(imageBoard)
        
        self.pieces = self.gameVM.createScenePieces()
                
        for piece in pieces.flatMap({ $0.value.values }) {
            self.addChild(piece)
        }
    }
    
    func startGame() async{
        self.gameVM.initGame()
        if let board = self.gameVM.game?.board {
            displayBoard(board)
        }
        self.gameVM.game!.addGameStartedListener { _ in
            print("Game Started")
        }
        
        self.gameVM.game!.addBoardChangedListener {
            print("*** BOARD CHANGED ***")
            print("*** ***** ******* ***")
            print($0)
        }
        
        self.gameVM.game!.addPlayerNotifiedListener({ board, player in
            
            let lastPlayerId = player.id == Owner.player1 ? Owner.player2 : Owner.player1
            
            if let ownerPieces = self.pieces[lastPlayerId]{
                // Recuperer la piece et l'enlever de la scene
                if let meeple = ownerPieces.first(where: { $0.value.isCurrentMeeple }) {
                    // if a meeple has current meeple status, reset
                    meeple.value.isCurrentMeeple = false;
                }
            }
            
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), it's your turn!")
            print("**************************************")
            self.gameVM.getNextPlayer()
            
            //try! await Persistance.saveGame(withName: "game", andGame: game2)
        })
        
        self.gameVM.game!.addMoveChosenCallbacksListener { _, move, player in
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), has chosen: \(move)")
            print("**************************************")
        }
        
        self.gameVM.game!.addInvalidMoveCallbacksListener { _, move, player, result in
           if result {
             return
           }

           print("**************************************")
           print("⚠️⚠️⚠️⚠️ Invalid Move detected: \(move) by \(player.name) (\(player.id))")
           print("**************************************")
        
           self.gameVM.triggerInvalidMoveCallback()
        }
        
        self.gameVM.game!.addPieceRemovedListener { row, column, piece in
            
            print("**************************************")
            print("XXXXXXX Piece Removed: \(piece)")
            print("**************************************")
            
            //self.triggerRemovePieceCallback()
            self.removePiece(for: piece.owner, animal: piece.animal)
        }
        
        self.gameVM.game!.addGameOverListener { board, result, player in
            switch(result){
            case .notFinished:
                print("⏳ Game is not over yet!")
            case .winner(winner: let o, reason: let r):
                print(board)
                print("**************************************")
                print("Game Over!!!")
                print("🥇🏆 and the winner is... \(o == .player1 ? "🟡" : "🔴") \(player?.name ?? "")!")
                switch(r){
                case .denReached:
                    print("🪺 the opponent's den has been reached.")
                case .noMorePieces:
                    print("🐭🐱🐯🦁🐘 all the opponent's animals have been eaten...")
                case .noMovesLeft:
                    print("⛔️ the opponent can not move any piece!")
                case .tooManyOccurences:
                    print("🔄 the opponent seem to like this situation... but enough is enough. Sorry...")
                }
                print("**************************************")
            default:
                break
            }
        }

        await self.gameVM.start()
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
        
        let cellWidth = imageBoard.size.width / CGFloat(self.gameVM.game!.board.nbColumns)
        let cellHeight = imageBoard.size.height / CGFloat(self.gameVM.game!.board.nbRows)
        
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
        let nextPlayer = self.gameVM.game!.rules.getNextPlayer()
        
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
    
    func removePiece(for owner: Owner, animal: Animal) {
        // Vérifiez si le propriétaire a des pièces
        if var ownerPieces = pieces[owner] {
            
            // Recuperer la piece et l'enlever de la scene
            if let meeple = ownerPieces[animal] {
                meeple.removeFromParent()
            }
            
            // Enlevez de la liste
            ownerPieces.removeValue(forKey: animal)
        }
    }
}
