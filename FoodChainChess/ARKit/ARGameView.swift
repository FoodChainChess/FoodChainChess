import Foundation
import SwiftUI
import ARKit
import RealityKit
import DouShouQiModel

class ARGameView: ARView {
    
    var initialTransform: Transform = Transform()
    var pieceEntities: [Owner: [Animal: PieceObject]] = [:]
    var playerManager : PlayerManager = PlayerManager.shared
    let animals: [Animal] = [.rat, .cat, .dog, .wolf, .leopard, .tiger, .lion, .elephant]
    var pieceObject : PieceObject? = nil
    
    
    @Published var game: Game?
    
    var currenPlayer: PlayerVM? {
        return playerManager.currentPlayer
    }
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        initGame()
        addListeners()
        setupBoardAndPieces()
        setupGestureRecognizers()
    }
    
    func initGame() {
        self.game = try! Game(
            withRules: ClassicRules(),
            andPlayer1: playerManager.selectedPlayer1.player,
            andPlayer2: playerManager.selectedPlayer2.player
        )
    }
    
    private func addListeners() {
        self.game!.addGameStartedListener { _ in
            print("Game Started")
        }
        
        self.game?.addPlayerNotifiedListener({ board, player in
            let lastPlayerId = player.id == Owner.player1 ? Owner.player2 : Owner.player1
            
            if let ownerPieces = self.pieceEntities[lastPlayerId] {
                if let pieceObject = ownerPieces.first(where: { $0.value.isCurrentPieceObject }) {
                    pieceObject.value.isCurrentPieceObject = false
                }
            }
            
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), it's your turn!")
            print("**************************************")
            
            self.playerManager.updateCurrentPlayer(currentPlayerId: player.id)
            
            if player is RandomPlayer {
                Task {
                    try! await player.chooseMove(in: board, with: self.game!.rules)
                }
            }
        })
        
        self.game!.addMoveChosenCallbacksListener { _, move, player in
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), has chosen: \(move)")
            print("**************************************")
        }
        
        self.game!.addInvalidMoveCallbacksListener { _, move, player, result in
           if result {
             return
           }

           print("**************************************")
           print("⚠️⚠️⚠️⚠️ Invalid Move detected: \(move) by \(player.name) (\(player.id))")
           print("**************************************")
            
            let allOwners: [Owner] = [.player1, .player2]
            for owner in allOwners {
                if let ownerPieces = self.pieceEntities[owner] {
                    if let pieceObject = ownerPieces.first(where: { $0.value.isCurrentPieceObject }) {
                        print("PIECE OBJECT: \(pieceObject.value.piece.animal)")
                        pieceObject.value.cellPosition = CGPoint(x: move.columnOrigin, y: move.rowOrigin)
                        
                        // Set piece to not current
                        pieceObject.value.isCurrentPieceObject = false
                    }
                }
            }
        }
        
        Task {
            try! await self.game?.start()
        }
    }
    
    func setupPieces(on anchor: AnchorEntity) {
        let player1 = HumanPlayer(withName: "Bruno", andId: .player1)!
        let player2 = HumanPlayer(withName: "BrunoBis", andId: .player2)!
        
        let player1Material = SimpleMaterial(color: .init(.red), isMetallic: false)
        let player2Material = SimpleMaterial(color: .init(.blue), isMetallic: false)
        
        let game = try! Game(withRules: ClassicRules(), andPlayer1: player1, andPlayer2: player2)
        
        let pieceScale: Float = 0.3
        
        for col in 0..<game.board.grid.count {
            for row in 0..<game.board.grid[col].count {
                if let piece = game.board.grid[col][row].piece {
                    let piece3D = try! Entity.loadModel(named: "\(piece.animal)")
                    
                    if piece.owner == player1.id {
                        piece3D.model?.materials = [player1Material]
                    } else if piece.owner == player2.id {
                        piece3D.model?.materials = [player2Material]
                        var transform = piece3D.transform
                        transform.rotation = simd_quatf(angle: .pi, axis: SIMD3<Float>(0, 1, 0)) * transform.rotation
                        piece3D.transform = transform
                    }
                    
                    let cellPosition = CGPoint(x: row, y: col)
                    let pieceObject = PieceObject(entity: piece3D, cellPosition: cellPosition, piece: piece)
                    piece3D.scale = [pieceScale, pieceScale, pieceScale]
                    piece3D.name = "\(col),\(row)"
                    piece3D.generateCollisionShapes(recursive: true)
                    anchor.addChild(piece3D)
                    
                    if pieceEntities[piece.owner] == nil {
                        pieceEntities[piece.owner] = [:]
                    }
                    pieceEntities[piece.owner]?[piece.animal] = pieceObject
                }
            }
        }
    }
    
    func setupBoardAndPieces() {
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        scene.addAnchor(anchor)
        let board3D = try? Entity.loadModel(named: "board")
        if let board3D {
            board3D.scale = [0.3, 0.3, 0.3]
            anchor.addChild(board3D)
        }
        setupPieces(on: anchor)
    }
    
    func setupGestureRecognizers() {
        
        for animal in self.animals {
            if let playerPieces = pieceEntities[.player1], let pieceObject = playerPieces[animal] {
                installGestures(.all, for: pieceObject.entity as! Entity & HasCollision).forEach { gestureRecognizer in
                    gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
                }
            }
            if let playerPieces = pieceEntities[.player2], let pieceObject = playerPieces[animal] {
                installGestures(.all, for: pieceObject.entity as! Entity & HasCollision).forEach { gestureRecognizer in
                    gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
                }
            }
        }
    }
    
    @objc private func handleGesture(_ recognizer: UIGestureRecognizer) {
        guard let translationGesture = recognizer as? EntityTranslationGestureRecognizer, let entity = translationGesture.entity else { return }
        
        for animal in animals {
            if let playerPieces = pieceEntities[.player1], let po = playerPieces[animal], entity == po.entity {
                self.pieceObject = po
                break
            } else if let playerPieces = pieceEntities[.player2], let po = playerPieces[animal], entity == po.entity {
                self.pieceObject = po
                break
            }
        }
        
        //stock la position de depart de l'entité choisi
        var startCellX = CGFloat(entity.position.x)
        var startCellY = CGFloat(entity.position.y)

        switch translationGesture.state {
        case .began:
            // Iterate through animals to find the pieceObject
            self.initialTransform = entity.transform
            print("Gesture began on entity: \(entity.name)")
        case .changed:
            // Optionally handle ongoing translation
            print("Gesture changed on entity: \(entity.name)")
        case .ended:
            let finalPosition = entity.position
            let cellX = round((CGFloat(finalPosition.x) - PieceObject.offset.x) / PieceObject.direction.dx)
            let cellY = round((CGFloat(finalPosition.z) - PieceObject.offset.y) / PieceObject.direction.dy)
            
            guard let currentPieceObject = pieceObject else{
                fatalError("Could not find piece entity")
            }
            
            // set piece object to current
            currentPieceObject.isCurrentPieceObject = true
            
            startCellX = CGFloat(currentPieceObject.entity.position.x)
            startCellY = CGFloat(currentPieceObject.entity.position.y)
            
            if cellX != startCellX || cellY != startCellY {
                let currentMove = Move(of: currentPieceObject.piece.owner,
                                       fromRow: Int(currentPieceObject.cellPosition.y),
                                       andFromColumn:  Int(currentPieceObject.cellPosition.x),
                                      toRow: Int(cellY),
                                      andToColumn: Int(cellX))
                self.currenPlayer?.currentMove = currentMove
                
                Task{
                    try! await( self.currenPlayer?.player as! HumanPlayer).chooseMove(currentMove)
                }
           }
            
           currentPieceObject.cellPosition = CGPoint(x: cellX, y: cellY)
            
            print("Gesture ended on entity: \(entity.name)")

        default:
            break
        }
    }
}
