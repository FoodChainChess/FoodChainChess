import SwiftUI
import SpriteKit
import DouShouQiModel

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAlert = false
    
    @ObservedObject var player1: PlayerVM
    @ObservedObject var player2: PlayerVM
    
    var gameScene: GameScene
    
    init(player1: PlayerVM, player2: PlayerVM) {
        self.player1 = player1
        self.player2 = player2
        self.gameScene = GameScene(size: CGSize(width: 700, height: 900), player1: player1, player2: player2)
    }
    
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
                PlayerProfilBoardView(imageSource: "", username: player2.player.name)
                Spacer()
            }.padding()
            Spacer()
            SpriteView(scene: gameScene)
            Spacer()
            PlayerProfilBoardView(imageSource: "", username: player1.player.name)
        }.task {
            try? await gameScene.game.start()
            //gameScene.game.addGameStartedListener(())
        }
    }
}

#Preview {
    BoardView(player1: PlayerVM(player: IAPlayer(withName: "Lou", andId: .player1)!), player2: PlayerVM(player: IAPlayer(withName: "LouBis", andId: .player2)!))
}
