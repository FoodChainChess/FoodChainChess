import SwiftUI

struct GamesView: View {
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: NSLocalizedString("Games", tableName: "Localization", comment: ""))
            List {
                Section(header: Text("01-02-2024")) {
                    ForEach((1...3), id: \.self) {_ in
                        ListItemGamesView()
                    }.listRowBackground(Colors.background)
                }
            }.scrollContentBackground(.hidden)
        }.background(Colors.background)
    }
}

//#Preview {
//    GamesView()
//}
