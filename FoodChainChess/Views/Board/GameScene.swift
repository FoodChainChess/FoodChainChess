import Foundation
import SpriteKit
import SwiftUI
import DouShouQiModel
import AVFoundation

class GameScene: SKScene, ObservableObject {

    var imageBoard: SKSpriteNode
    //Variable pour binder dans la view quand la game est fini
    var gameEndResult : String = ""
        
    var pieces: [Owner: [Animal: SpriteMeeple]] = [:]
    var highlightedNodes: [SKShapeNode] = []
    
    var audioPlayer: AVAudioPlayer?
    var rowEaten: Int?
    var columnEaten: Int?
    
    /// Instance de game vm
    @ObservedObject var gameVM: GameVM
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        self.gameVM = GameVM()
        
        self.imageBoard = SKSpriteNode(imageNamed: "Board")
        
        super.init(size: size)
        
        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(imageBoard)
        
        self.pieces = [:]
    }
    
    /// Sets the game scene's images and meeples.
    func setGameScene() {
        // set the board according to game rules
        imageBoard.removeFromParent()
        
        if self.gameVM.game?.rules is ClassicRules {
            self.imageBoard = SKSpriteNode(imageNamed: "Board")
        }
        else {
            self.imageBoard = SKSpriteNode(imageNamed: "LittleBoard")
        }
        
        self.addChild(self.imageBoard)
        
        // set pieces according to game rules
        self.pieces = self.gameVM.createScenePieces()
        
        for piece in self.pieces.flatMap({ $0.value.values }) {
            self.addChild(piece)
        }
        
        // display the board
        if let board = self.gameVM.game?.board {
            displayBoard(board)
        }
    }
    
    /// Resets the game scene, removing images and meeples.
    func resetGameScene() {
        self.imageBoard.removeFromParent()
        
        for piece in self.pieces.flatMap({ $0.value.values }) {
            piece.removeFromParent()
        }
        
        // display the board
        if let board = self.gameVM.game?.board {
            displayBoard(board)
        }
    }
    
    func startGame() async{
        if let board = self.gameVM.game?.board {
            displayBoard(board)
        }
        self.gameVM.game!.addGameStartedListener { _ in
            print("Game Started")
        }
        
        self.gameVM.game!.addBoardChangedListener { board in
            print("*** BOARD CHANGED ***")
            print("*** ***** ******* ***")
            
            if let rowEaten = self.rowEaten, let columnEaten = self.columnEaten {
                self.playSound(board: board)
            }
        }
        
        self.gameVM.game?.addPlayerNotifiedListener({ board, player in
            self.displayBoard(board)

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
            
            // Update the current player instance on the player manager
            self.gameVM.updateCurrentPlayerVM(currentPlayerId: player.id)
            
            if player is RandomPlayer {
                try! await player.chooseMove(in: board, with: self.gameVM.game!.rules)
            }
            
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
            
            self.rowEaten = row
            self.columnEaten = column
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
        
        let cellWidth = imageBoard.size.width / CGFloat(self.gameVM.game!.board.nbColumns)
        let cellHeight = imageBoard.size.height / CGFloat(self.gameVM.game!.board.nbRows)
        
        for move in moves {
            let highlight = SKShapeNode(circleOfRadius: cellWidth / 4)
            highlight.fillColor = .green
            highlight.strokeColor = .clear
            
            let xPosition = CGFloat(move.columnDestination) * cellWidth - imageBoard.size.width / 2 + cellWidth / 2
            let yPosition = CGFloat(move.rowDestination) * cellHeight - imageBoard.size.height / 2 + cellHeight / 2
            highlight.position = CGPoint(x: xPosition, y: yPosition)
            highlight.zPosition = 100
            
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
    
    /// Supprimer une pièce
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
    
    /// Jouer le son d'un animal lorsqu'il mange une pièce
    func playSound(board: Board){
        if let rowEaten = rowEaten, let columnEaten = columnEaten  {
            let soundFileName = board.grid[rowEaten][columnEaten].piece?.animal.soundFileName

            if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") {
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    self.audioPlayer?.play()
                } catch {
                    print("Erreur lors de la lecture du fichier son : \(error.localizedDescription)")
                }
            } else {
                print("Fichier son \(String(describing: soundFileName)) introuvable.")
            }
            
            // Remettre rowEaten et columnEaten à nil
            self.rowEaten = nil
            self.columnEaten = nil
        }
    }
    
}
