import Foundation
import SwiftUI
import ARKit
import RealityKit
import DouShouQiModel


class PieceObject {
    static var offset = CGPoint(x: -0.3435 * 0.3, y: -0.458 * 0.3)
    static var direction = CGVector(dx: 0.1145 * 0.3, dy: 0.1145 * 0.3)
    
    var isCurrentPieceObject : Bool = false
    var entity: Entity //C'est un attribut unique à chaque Piece
    var piece : Piece //Piece associé à l'objet 3D
    var originalPosition: SIMD3<Float>
    var cellPosition: CGPoint {
        didSet {
            updatePosition()
        }
    }
    
    init(entity: Entity, cellPosition: CGPoint, piece: Piece) {
        self.piece = piece
        self.entity = entity
        self.cellPosition = cellPosition
        self.originalPosition = SIMD3<Float>(x: Float(PieceObject.offset.x + PieceObject.direction.dx * cellPosition.x),
                                             y: 0.02,
                                             z: Float(PieceObject.offset.y + PieceObject.direction.dy * cellPosition.y))
        updatePosition()
    }
    private func updatePosition() {
        entity.position.x = Float(PieceObject.offset.x + PieceObject.direction.dx * cellPosition.x)
        entity.position.z = Float(PieceObject.offset.y + PieceObject.direction.dy * cellPosition.y)
    }
}
