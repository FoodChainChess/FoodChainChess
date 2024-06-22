import Foundation
import SwiftUI
import ARKit
import RealityKit

class ARGameView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        addBoardToTheFloor()
    }
    
    func addBoardToTheFloor() {
        //let configuration = ARWorldTrackingConfiguration()
        //session.run(configuration)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        scene.addAnchor(anchor)
        let board3D = try? Entity.load(named: "board")
        if let board3D {
            board3D.scale = [0.3, 0.3, 0.3]
            anchor.addChild(board3D)
        }
    }
    c
}
