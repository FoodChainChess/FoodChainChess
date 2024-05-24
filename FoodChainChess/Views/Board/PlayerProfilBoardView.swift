import SwiftUI

struct PlayerProfilBoardView: View {
    var imageSource: String
    var username: String
    
    var body: some View {
        HStack {
            PlayerFaceView(imageSource: imageSource, circleWidth: 40, circleHeight: 40)
            Text(username)
        }.padding()
    }
}

//#Preview {
//    PlayerProfilBoardView(imageSource: "", username: "Username")
//}

struct PlayerProfilBoardViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
    }
}
