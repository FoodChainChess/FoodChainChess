import SwiftUI

struct ScoreboardView: View {
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "Scoreboard")
            List {
                ForEach((1...10), id: \.self) {_ in
                    ListItemScoreboardView()
                }.listRowBackground(Colors.background)
            }.scrollContentBackground(.hidden).background(Color.clear)
        }.background(Colors.background)
    }
}

//#Preview {
//    ScoreboardView()
//}
