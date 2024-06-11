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
    }
    
    func applyConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
//        let configuration = ARGeoTrackingConfiguration()
//        let configuration = ARFaceTrackingConfiguration()
//        let configuration = ARBodyTrackingConfiguration()
        session.run(configuration)
    }
    
    func defineAnchors() {
       // let anchor = AnchorEntity(world: .zero)
//        let anchor = AnchorEntity(.camera)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2,0.2)))
//        let anchor = AnchorEntity(plane: .vertical)
//        let anchor = AnchorEntity(.face)
//        let anchor = AnchorEntity(.body)
//        let anchor = AnchorEntity(.image(group: "group", name: "name"))
        
        scene.addAnchor(anchor)
    }
}
