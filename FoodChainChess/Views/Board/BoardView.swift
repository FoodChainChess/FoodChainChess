import SwiftUI
import SpriteKit
import DouShouQiModel

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAlert = false
    
    @ObservedObject var gameScene: GameScene
    
    init(player1: Player, player2: Player) {
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
                PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameScene.gameVM.player2VM.player.name)
                Spacer()
            }.padding()
            Spacer()
            SpriteView(scene: self.gameScene)
            Spacer()
            PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameScene.gameVM.player1VM.player.name)
        }.background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.yellow]),
                startPoint: .top,
                endPoint: .bottom
            ) //couleur à changer en fonction du joueur en cours (J1 - white & yellow / J2 - red & white)
        ).task {
            await self.gameScene.startGame()
            
        }.sheet(isPresented: $gameScene.isShowingEndPopUp) {
            EndGamePopUpView(isShowing: $gameScene.isShowingEndPopUp, playerOneScore: 1, playerTwoScore: 0, playerUsername1: gameScene.gameVM.player1VM.player.name, playerUsername2: gameScene.gameVM.player2VM.player.name, winReason: gameScene.gameEndResult)
        }
    }
}

struct BoardViewPreview: PreviewProvider {
    static var previews: some View {
        
        let player1: Player = HumanPlayer(withName: "LouSusQi", andId: .player1)!
        let player2: Player = HumanPlayer(withName: "LouSusQuoi", andId: .player2)!
        
        BoardView(player1: player1, player2: player2)
        
    }
}
//#Preview {
//    BoardView(player1: PlayerVM(player: IAPlayer(withName: "Lou", andId: .player1)!), player2: PlayerVM(player: IAPlayer(withName: "LouBis", andId: .player2)!))
//}
