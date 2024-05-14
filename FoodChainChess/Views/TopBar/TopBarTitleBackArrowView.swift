import SwiftUI

struct TopBarTitleBackArrowView: View {
    var title: String
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(Colors.text)
            Spacer()
            Text(title)
            Spacer()
        }.padding().frame(height: 50)
    }
}

//#Preview {
//    TopBarTitleBackArrowView(title: "Parties")
//}
