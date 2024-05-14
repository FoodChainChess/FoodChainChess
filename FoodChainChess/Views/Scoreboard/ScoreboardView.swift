import SwiftUI

struct ScoreboardView: View {
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "Scoreboard")
            List {
                ListItemScoreboardView()
                ListItemScoreboardView()
                ListItemScoreboardView()
                ListItemScoreboardView()
                ListItemScoreboardView()
                ListItemScoreboardView()
            }
        }
    }
}

//#Preview {
//    ScoreboardView()
//}
