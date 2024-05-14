import SwiftUI

struct RegisteredGamesView: View {
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "Registered Games")
            List {
                Section(header: Text("01-02-2024")) {
                    ListItemRegisteredGamesView()
                    ListItemRegisteredGamesView()
                    ListItemRegisteredGamesView()
                }
            }
        }
    }
}

#Preview {
    RegisteredGamesView()
}
