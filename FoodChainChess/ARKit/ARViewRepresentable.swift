import Foundation
import SwiftUI

struct ARViewRepresentable: UIViewRepresentable {
    
    @EnvironmentObject var gameManager: GameSceneManager

    func makeUIView(context: Context) -> ARGameView {
        let arView = ARGameView()
        arView.setGameManager(gameManager)
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
