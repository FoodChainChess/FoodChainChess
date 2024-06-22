import Foundation
import SwiftUI
import ARKit
import RealityKit
import DouShouQiModel
import FoodChainChess


class Piece {
    var entity: Entity
    var originalPosition: SIMD3<Float>
    var cellPosition: CGPoint {
        didSet {
            updatePosition()
        }
    }
    
    static var offset = CGPoint(x: -0.5 * 0.3, y: -0.35 * 0.3)
    static var direction = CGVector(dx: 0.25 * 0.3, dy: 0.2 * 0.3)
    
    init(entity: Entity, cellPosition: CGPoint) {
        self.entity = entity
        self.cellPosition = cellPosition
        self.originalPosition = SIMD3<Float>(x: Float(Piece.offset.x + Piece.direction.dx * cellPosition.x),
                                             y: 0.02,
                                             z: Float(Piece.offset.y + Piece.direction.dy * cellPosition.y))
        updatePosition()
    }
    
    private func updatePosition() {
        entity.position.x = Float(Piece.offset.x + Piece.direction.dx * cellPosition.x)
        entity.position.z = Float(Piece.offset.y + Piece.direction.dy * cellPosition.y)
    }
}


class ARGameView: ARView {
    
    var initialTransform: Transform = Transform()
    var pieceEntities: [Piece] = []
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        setupBoardAndPieces()
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
                        let pieceModel = try! Entity.loadModel(named: "\(piece.animal)")
                        
                        // Appliquer le matériau en fonction du joueur
                        if piece.owner == player1.id {
                            pieceModel.model?.materials = [player1Material]
                        } else if piece.owner == player2.id {
                            pieceModel.model?.materials = [player2Material]
                            
//                            // Faire rotate la pièce de 180 degrés pour player2
//                            var transform = pieceModel.transform
//                            transform.rotation = simd_quatf(angle: .pi, axis: SIMD3<Float>(1, 0, 0))
//                            pieceModel.transform = transform
                        }
                        
                        let cellPosition = CGPoint(x: row, y: col)
                        let pieceObject = Piece(entity: pieceModel, cellPosition: cellPosition)
                        pieceModel.scale = [pieceScale, pieceScale, pieceScale]
                        pieceModel.name = "\(col),\(row)"
                        pieceModel.generateCollisionShapes(recursive: true)
                        anchor.addChild(pieceModel)
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
