import Foundation
import SwiftUI
import ARKit
import RealityKit
import DouShouQiModel
import FoodChainChess


class ARGameView: ARView {
    
    var initialTransform: Transform = Transform()
    var pieceEntities: [PieceObject] = []
    var arGameManager : ARGameManager
    
    required init(frame frameRect: CGRect) {
        
        self.arGameManager = ARGameManager()
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        setupBoardAndPieces()
    
        //Setup les gestures pour chaque piece
        for piece in pieceEntities {
            installGestures(.all, for: piece.entity as! Entity & HasCollision).forEach { gestureRecognizer in
                gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
            }
        }
        Task{
            await self.arGameManager.startGame()
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
                        pieceEntities.append(pieceObject)
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
