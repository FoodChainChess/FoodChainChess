import SwiftUI
import SpriteKit

struct BoardView: View {
    var gameScene : GameScene = GameScene(size: CGSize(width: 940, height: 740))
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(Colors.text)
                Spacer()
                PlayerProfilBoardView(imageSource: "", username: "Username 2").rotationEffect(.degrees(180))
                Spacer()
            }.padding()
            Spacer()
            SpriteView(scene: gameScene)
            Spacer()
            PlayerProfilBoardView(imageSource: "", username: "Username 1")
        }
    }
}

#Preview {
    BoardView()
}
