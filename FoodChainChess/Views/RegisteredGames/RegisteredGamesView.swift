import SwiftUI

struct RegisteredGamesView: View {
    @State var numbers = [1, 2, 3]
    
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "Registered Games")
            List {
                Section(header: Text("01-02-2024")) {
                    ForEach(numbers.indices, id: \.self) { index in
                        ListItemRegisteredGamesView()
                    }
                    .onDelete(perform: deleteNumber)
                }
            }.scrollContentBackground(.hidden)
        }
    }
    
    func deleteNumber(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

//#Preview {
//    RegisteredGamesView()
//}
