import SwiftUI
import SpriteKit

struct BoardView: View {
    //var gameScene : GameScene = GameScene(size: CGSize(width: 900, height: 700))
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
                        title: Text("Save the game before quitting ?", tableName: "Localization"),
                        message: Text("If you don't save the game, it will be lost.", tableName: "Localization"),

                        primaryButton: .default(
                            Text("Yes", tableName: "Localization"),
                            action: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        ),

                        secondaryButton: .destructive(
                            Text("No", tableName: "Localization")
                        )
                    )
                }
                Spacer()
                PlayerProfilBoardView(imageSource: "", username: "Username 2").rotationEffect(.degrees(180))
                Spacer()
            }.padding()
            GeometryReader { geometry in
                SpriteView(scene: GameScene(size: CGSize(width: geometry.size.width, height: geometry.size.height)))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(.red)
            }.edgesIgnoringSafeArea(.all)
//            SpriteView(scene: gameScene)
//                .aspectRatio(contentMode: .fit)
//                                    .rotationEffect(.degrees(90))
//                                    .background(.red)
//                                    .scaledToFill()
            PlayerProfilBoardView(imageSource: "", username: "Username 1")
        }
    }
}

#Preview {
    BoardView()
}
