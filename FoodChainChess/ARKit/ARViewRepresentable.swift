import Foundation
import SwiftUI

struct ARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> ARGameView {
        ARGameView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
