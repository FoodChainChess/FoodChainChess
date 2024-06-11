import SwiftUI
import SpriteKit
import DouShouQiModel

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAlert = false
        
    var gameScene: GameScene
    
    /// Permet un access rapide a l'instance de gameVM
    var gameVM: GameVM {
        return self.gameScene.gameVM
    }
    /// Permet un access rapide a l'instance de game
    var game: Game {
        return self.gameScene.gameVM.game
    }
    
    init(player1: Player, player2: Player) {
        let gameVM = GameVM(player1: player1, player2: player2)
        self.gameScene = GameScene(size: CGSize(width: 700, height: 900), gameVM: gameVM)
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
                PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameVM.player2VM.player.name)
                Spacer()
            }.padding()
            Spacer()
            SpriteView(scene: self.gameScene)
            Spacer()
            PlayerProfilBoardView(imageSource: "defaultAvatarPicture", username: self.gameVM.player1VM.player.name)
        }.task {
            self.gameVM.game.addGameStartedListener { _ in
               print("* Game Started")
                
             // print(self.game.board)
            }
            
            self.game.addBoardChangedListener { _ in
                print("*** BOARD CHANGED ***")
                print("*** ***** ******* ***")
                // print(self.game.board)
                print()
            }
            
            self.game.addBoardChangedListener {
                print("*** changed 2 ***")
                print($0)
            }
            
            self.game.addPlayerNotifiedListener({ board, player in
                print("**************************************")
                print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), it's your turn!")
                print("**************************************")
                //try! await Persistance.saveGame(withName: "game", andGame: game2)
                
//                while() {
//                    
//                }
            })
            
            self.game.addMoveChosenCallbacksListener { _, move, player in
                print("**************************************")
                print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), has chosen: \(move)")
                print("**************************************")
            }
            
            self.game.addInvalidMoveCallbacksListener { _, move, player, result in
               print("**************************************")
               print("⚠️⚠️⚠️⚠️ Invalid Move detected: \(move) by \(player.name) (\(player.id))")
               print("**************************************")
               //_ = readLine()
           }
            await self.gameVM.start()
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
