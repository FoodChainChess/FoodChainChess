import SwiftUI

struct ListItemRegisteredGamesView: View {
    var body: some View {
        HStack {
            PlayerFaceView(imageSource: "", circleWidth: 40, circleHeight: 40)
            Text("vs")
            PlayerFaceView(imageSource: "", circleWidth: 40, circleHeight: 40)
            Spacer()
            Text("Tour 34")
            Spacer()
            Image(systemName: "play")
                .imageScale(.large)
                .foregroundColor(Colors.text)
        }.padding()
    }
}

#Preview {
    ListItemRegisteredGamesView()
}
