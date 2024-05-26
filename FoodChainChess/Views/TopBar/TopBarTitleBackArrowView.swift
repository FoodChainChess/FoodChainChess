import SwiftUI

struct TopBarTitleBackArrowView: View {
    var title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(Colors.text)
            }
            Spacer()
            Text(title)
            Spacer()
        }
        .padding()
        .frame(height: 50)
    }
}

//#Preview {
//    TopBarTitleBackArrowView(title: "Parties")
//}
