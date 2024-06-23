import Foundation
import SwiftUI
import ARKit
import RealityKit


class PieceObject {
    static var offset = CGPoint(x: -0.2, y: -0.25)
    static var direction = CGVector(dx: 0.074, dy: 0.06)
    
    var isCurrentPieceObject : Bool = false
    var entity: Entity
    var originalPosition: SIMD3<Float>
    var cellPosition: CGPoint {
        didSet {
            updatePosition()
        }
    }
    
    init(entity: Entity, cellPosition: CGPoint) {
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
