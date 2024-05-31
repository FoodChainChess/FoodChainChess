import SwiftUI

struct RegisteredGamesView: View {
    @State var numbers = [1, 2, 3]
    
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: NSLocalizedString("Registered Games", tableName: "Localization", comment: ""))
            List {
                Section(header: Text("01-02-2024")) {
                    ForEach(numbers.indices, id: \.self) { index in
                        ListItemRegisteredGamesView()
                    }
                    .onDelete(perform: deleteNumber).listRowBackground(Colors.background)
                }
            }.scrollContentBackground(.hidden)
        }.background(Colors.background)
    }
    
    func deleteNumber(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

struct RegisterGamesPreview: PreviewProvider {
    static var previews: some View {
        RegisteredGamesView()
    }
}

//#Preview {
//    RegisteredGamesView()
//}
