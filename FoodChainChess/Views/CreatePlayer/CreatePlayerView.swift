import SwiftUI

struct CreatePlayerView: View {
    @State private var name = ""
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: NSLocalizedString("New Player", tableName: "Localization", comment: ""))
            Spacer()
            ProfilePictureView()
            TextField(NSLocalizedString("Enter your name", tableName: "Localization", comment: ""), text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
            Spacer()
        }.background(Colors.background)
    }
}

struct CreatePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlayerView()
    }
}
