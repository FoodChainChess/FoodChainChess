import SwiftUI
import DouShouQiModel

struct ScoreboardView: View {
    var playerManager: PlayerManager = PlayerManager.shared
    
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: NSLocalizedString("Scoreboard", tableName: "Localization", comment: ""))
            
            List(Array(playerManager.createdPlayers.enumerated()), id: \.element.name) { index, player in
                ListItemScoreboardView(player: player, index: index)
            }
            .listRowBackground(Colors.background)
        }
        .background(Colors.background)
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}

//#Preview {
//    ScoreboardView()
//}
