import SwiftUI

struct CreatePlayerView: View {
    @State private var name = ""
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "New Player")
            Spacer()
            ProfilePictureView()
            TextField("Enter your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
            Spacer()
        }
    }
}

struct CreatePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlayerView()
    }
}
