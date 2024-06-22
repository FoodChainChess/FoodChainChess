import SwiftUI
import SpriteKit
import DouShouQiModel

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAlert = false
        
    @EnvironmentObject var gameManager: GameSceneManager
        
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
                PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameManager.gameScene.gameVM.player2VM.player.name)
                Spacer()
            }.padding()
            Spacer()
            SpriteView(scene: self.gameManager.gameScene)
            Spacer()
            PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameManager.gameScene.gameVM.player1VM.player.name)
        }.task {
            await self.gameManager.gameScene.startGame()
            
        }
    }
}

struct BoardViewPreview: PreviewProvider {
    static var previews: some View {        
        BoardView()
    }
}
//#Preview {
//    BoardView(player1: PlayerVM(player: IAPlayer(withName: "Lou", andId: .player1)!), player2: PlayerVM(player: IAPlayer(withName: "LouBis", andId: .player2)!))
//}
