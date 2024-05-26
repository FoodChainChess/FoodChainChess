import SwiftUI
import SpriteKit

struct BoardView: View {
    var gameScene : GameScene = GameScene(size: CGSize(width: 940, height: 740))
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAlert = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {isShowingAlert = true }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Colors.text)
                }
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("Save the game before quitting ?"),
                        message: Text("If you don't save the game, it will be lost."),

                        primaryButton: .default(
                            Text("Yes"),
                            action: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        ),

                        secondaryButton: .destructive(
                            Text("No")
                        )
                    )
                }
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

//#Preview {
//    BoardView()
//}
