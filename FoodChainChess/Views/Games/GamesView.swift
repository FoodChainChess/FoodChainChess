import SwiftUI

struct GamesView: View {
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "Games")
            List {
                Section(header: Text("01-02-2024")) {
                    ListItemGamesView()
                    ListItemGamesView()
                    ListItemGamesView()
                }
            }.scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    GamesView()
}
