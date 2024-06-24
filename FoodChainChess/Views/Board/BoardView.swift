import SwiftUI
import SpriteKit
import DouShouQiModel

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAlert = false
        
    @EnvironmentObject var gameManager: GameSceneManager
    
    @ObservedObject var playerManager: PlayerManager = PlayerManager.shared
    
    private var backgroundColor: LinearGradient {
        let colors: [Color]
        if self.playerManager.currentPlayer?.player.id == .player1 {
            colors = [Color.white, Color.yellow]
        } else {
            colors = [Color.red, Color.white]
        }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {isShowingAlert = true }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.black)
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
                PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameManager.gameScene.gameVM.playerManager.selectedPlayer2.player.name)
                Spacer()
            }.padding()
            Spacer()
            SpriteView(scene: self.gameManager.gameScene)
            Spacer()
            PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameManager.gameScene.gameVM.playerManager.selectedPlayer1.player.name)
        // add linear gadient changes
        }
        .background(backgroundColor)
        .onAppear(){
            self.gameManager.gameScene.gameVM.initGame()
        }
        .task {
            // init game instance
            self.gameManager.gameScene.gameVM.initGame()

            // add game ended listener (here to be able to bind with gameManager)
            self.gameManager.gameScene.gameVM.game!.addGameOverListener { board, result, player in
                
                // game ended messsage holder
                var gameEndedMessage: String

                switch(result){
                case .notFinished:
                    print("⏳ Game is not over yet!")
                case .winner(winner: let o, reason: let result):
                    print(board)
                    print("**************************************")
                    print("Game Over!!!")
                    print("🥇🏆 and the winner is... \(o == .player1 ? "🟡" : "🔴") \(player?.name ?? "")!")
                    switch(result){
                    case .denReached:
                        print("🪺 the opponent's den has been reached.")
                        gameEndedMessage = "🪺 the opponent's den has been reached."
                    case .noMorePieces:
                        print("🐭🐱🐯🦁🐘 all the opponent's animals have been eaten...")
                        gameEndedMessage = "🐭🐱🐯🦁🐘 all the opponent's animals have been eaten..."
                    case .noMovesLeft:
                        print("⛔️ the opponent can not move any piece!")
                        gameEndedMessage = "⛔️ the opponent can not move any piece!"
                    case .tooManyOccurences:
                        print("🔄 the opponent seem to like this situation... but enough is enough. Sorry...")
                        gameEndedMessage = "🔄 the opponent seem to like this situation... but enough is enough. Sorry..."
                    }
                    print("**************************************")
                    
                    self.gameManager.gameScene.gameEndResult = gameEndedMessage
                    
                    // ! Mettre a jour UI dans le thread principale
                    // On fait ça pq SWIFT demande que les changements affectent la vue se fassent dans le main thread
                    DispatchQueue.main.async {
                        self.gameManager.isGameEnded = true
                        
                    }
                    
                default:
                    break
                }
            }
            await self.gameManager.gameScene.startGame()
        }
        .navigationBarHidden(true)
        NavigationLink(
            destination: EndGamePopUpView(playerOneScore: 1, playerTwoScore: 0, playerUsername1: "TUTU", playerUsername2: "TOTO", winReason: self.gameManager.gameScene.gameEndResult.description).navigationBarBackButtonHidden(true),
            isActive: $gameManager.isGameEnded,
            label: { EmptyView() }
        )
    }
}

struct BoardViewPreview: PreviewProvider {
    static var previews: some View {        
        BoardView()
    }
}
