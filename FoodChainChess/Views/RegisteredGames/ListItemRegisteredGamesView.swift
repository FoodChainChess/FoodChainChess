import SwiftUI

struct ListItemRegisteredGamesView: View {
    var body: some View {
        HStack {
            PlayerFaceView(imageSource: UIImage(named: "defaultAvatarPicture")!, circleWidth: 40, circleHeight: 40)
            Text("vs")
            PlayerFaceView(imageSource: UIImage(named: "defaultAvatarPicture")!, circleWidth: 40, circleHeight: 40)
            Spacer()
            Text("\(NSLocalizedString("Round", tableName: "Localization", comment: "")) 34")
            Spacer()
            Image(systemName: "play")
                .imageScale(.large)
                .foregroundColor(Colors.text)
        }.padding()
    }
}

//#Preview {
//    ListItemRegisteredGamesView()
//}
