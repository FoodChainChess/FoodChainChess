import SwiftUI

struct ScoreboardView: View {
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: NSLocalizedString("Scoreboard", tableName: "Localization", comment: ""))
            List {
                ForEach((1...10), id: \.self) {_ in
                    ListItemScoreboardView()
                }.listRowBackground(Colors.background)
            }.scrollContentBackground(.hidden).background(Color.clear)
        }.background(Colors.background)
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
