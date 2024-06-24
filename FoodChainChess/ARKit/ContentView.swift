import SwiftUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameManager: GameSceneManager
    @ObservedObject var playerManager: PlayerManager = PlayerManager.shared

    var body: some View {
        ARViewRepresentable()
            .ignoresSafeArea()
            .environmentObject(gameManager)
            .alert(isPresented: self.$gameManager.isGameEnded) {
                Alert(
                    title: Text("Game Over"),
                    message: Text("Winner: \(self.playerManager.selectedPlayer1.player.id == self.gameManager.gameWinner ? self.playerManager.selectedPlayer1.player.name : self.playerManager.selectedPlayer2.player.name)\n\(self.gameManager.gameScene.gameEndResult.description)"),
                    dismissButton: .default(Text("End"), action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                )
            }
    }
}
