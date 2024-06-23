import Foundation
import SwiftUI
import ARKit
import RealityKit
import DouShouQiModel


class ARGameView: ARView {
    
    var initialTransform: Transform = Transform()
    var pieceEntities: [Owner: [Animal: PieceObject]] = [:]
    
    var playerManager : PlayerManager = PlayerManager.shared
    
    
    /// Le game
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
        
        setupBoardAndPieces()
        addListeners()
        
        
        let animals: [Animal] = [.rat, .cat, .dog, .wolf, .leopard, .tiger, .lion, .elephant]

        for animal in animals {
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
        
        
//        //Setup les gestures pour chaque piece
//        for piece in pieceEntities {
//            installGestures(.all, for: piece.entity as! Entity & HasCollision).forEach { gestureRecognizer in
//                gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
//            }
//        }
    }
    
    func initGame() {
        self.game = try! Game(
            withRules: ClassicRules(),
            andPlayer1: playerManager.selectedPlayer1.player,
            andPlayer2: playerManager.selectedPlayer2.player
        )
    }
    
    private func addListeners() {
        
        
        self.game?.addPlayerNotifiedListener({ board, player in

            let lastPlayerId = player.id == Owner.player1 ? Owner.player2 : Owner.player1
            
            if let ownerPieces = self.pieceEntities[lastPlayerId]{
                // Recuperer la piece et l'enlever de la scene
                if let pieceObject = ownerPieces.first(where: { $0.value.isCurrentPieceObject }) {
                    // if a meeple has current meeple status, reset
                    pieceObject.value.isCurrentPieceObject = false;
                }
            }
            
            
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), it's your turn!")
            print("**************************************")
            
            // Update the current player instance on the player manager
            self.playerManager.updateCurrentPlayer(currentPlayerId: player.id)
            
            if player is RandomPlayer {
                try! await player.chooseMove(in: board, with: self.game!.rules)
            }
        })
        
        Task {
          try! await game?.start()
        }
    }
    
    func setupPieces(on anchor: AnchorEntity) {
        let player1 = HumanPlayer(withName: "Bruno", andId: .player1)!
        let player2 = HumanPlayer(withName: "BrunoBis", andId: .player2)!
        
        // Matériaux pour chaque joueur
        let player1Material = SimpleMaterial(color: .init(.red), isMetallic: false)
        let player2Material = SimpleMaterial(color: .init(.blue), isMetallic: false)
        
        let game = try! Game(withRules: ClassicRules(), andPlayer1: player1, andPlayer2: player2)
        
        let pieceScale: Float = 0.6
        
        for col in 0..<game.board.grid.count {
                for row in 0..<game.board.grid[col].count {
                    if let piece = game.board.grid[col][row].piece {
                        let piece3D = try! Entity.loadModel(named: "\(piece.animal)")
                        
                        // Appliquer le matériau en fonction du joueur
                        if piece.owner == player1.id {
                            piece3D.model?.materials = [player1Material]
                        } else if piece.owner == player2.id {
                            piece3D.model?.materials = [player2Material]
                            
//                            // Faire rotate la pièce de 180 degrés pour player2
                            var transform = piece3D.transform
                            transform.rotation = simd_quatf(angle: .pi, axis: SIMD3<Float>(0, 1, 0)) * transform.rotation
                            piece3D.transform = transform
                        }
                        
                        let cellPosition = CGPoint(x: row, y: col)
                        let pieceObject = PieceObject(entity: piece3D, cellPosition: cellPosition)
                        piece3D.scale = [pieceScale, pieceScale, pieceScale]
                        piece3D.name = "\(col),\(row)"
                        piece3D.generateCollisionShapes(recursive: true)
                        anchor.addChild(piece3D)
                        pieceEntities[piece.owner]?[piece.animal] = pieceObject
                    }
                }
            }
    }
    
    func setupBoardAndPieces() {
        //let configuration = ARWorldTrackingConfiguration()
        //session.run(configuration)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        scene.addAnchor(anchor)
        let board3D = try? Entity.loadModel(named: "board")
        if let board3D {
            board3D.scale = [0.6, 0.6, 0.6]
            anchor.addChild(board3D)
        }
        setupPieces(on: anchor)
    }
    
    @objc private func handleGesture(_ recognizer: UIGestureRecognizer) {
        guard let translationGesture = recognizer as? EntityTranslationGestureRecognizer, let entity = translationGesture.entity else { return }
            
            switch translationGesture.state {
            case .began:
                self.initialTransform = entity.transform
            case .ended:
                entity.move(to: initialTransform, relativeTo: entity.parent, duration: 1)
            default:
                break
            }
    }

}
