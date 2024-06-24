import SwiftUI
import SpriteKit
import DouShouQiModel

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowingAlert = false
    @State private var isShowingEndgameAlert = false
    @State private var endgameMessage = ""
    @State private var winnerName = ""
    
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
    
    private func startGameInstance() async {
        // init game instance
        self.gameManager.gameScene.gameVM.initGame()
        
        // set game scene maintenant que game a été créer
        self.gameManager.gameScene.setGameScene()

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
                
                DispatchQueue.main.async {
                    self.winnerName = player?.name ?? ""
                    self.endgameMessage = gameEndedMessage
                    self.isShowingEndgameAlert = true
                }
            default:
                break
            }
        }
        await self.gameManager.gameScene.startGame()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PlayerProfilBoardView(imageSource: playerManager.getAvatarImage(for: self.gameManager.gameScene.gameVM.playerManager.selectedPlayer2.player.name), username: self.gameManager.gameScene.gameVM.playerManager.selectedPlayer2.player.name)
                Spacer()
            }.padding()
            Spacer()
            SpriteView(scene: self.gameManager.gameScene)
            Spacer()
            PlayerProfilBoardView(imageSource: playerManager.getAvatarImage(for: self.gameManager.gameScene.gameVM.playerManager.selectedPlayer1.player.name), username: self.gameManager.gameScene.gameVM.playerManager.selectedPlayer1.player.name)
        }
        .background(backgroundColor)
        .task {
            self.gameManager.gameScene.resetGameScene()
            await self.startGameInstance()
        }
        .alert(isPresented: $isShowingEndgameAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Winner: \(winnerName)\n\(endgameMessage)"),
                dismissButton: .default(Text("End"), action: {
                    self.isShowingEndgameAlert = false
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
}

struct BoardViewPreview: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
