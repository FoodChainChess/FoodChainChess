import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameSceneManager
    @ObservedObject var playerManager: PlayerManager = PlayerManager.shared

    var body: some View {
        ARViewRepresentable()
            .ignoresSafeArea()
            .environmentObject(gameManager)
//        NavigationLink(
//            destination: EndGamePopUpView(playerOneScore: 1, playerTwoScore: 0, playerUsername1: playerManager.selectedPlayer1.player.name, playerUsername2: playerManager.selectedPlayer2.player.name, winReason: self.gameManager.gameScene.gameEndResult.description).navigationBarBackButtonHidden(true),
//            isActive: $gameManager.isGameEnded,
//            label: { EmptyView() }
//        )

    }
}
