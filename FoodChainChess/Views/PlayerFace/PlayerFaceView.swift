import SwiftUI

struct PlayerFaceView: View {
    var imageSource: String
    var circleWidth: CGFloat
    var circleHeight: CGFloat
    var body: some View {
        Image(imageSource)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: circleWidth, height: circleHeight)
            .clipShape(Circle())
            .overlay(Circle().stroke(Colors.text))
    }
}

//#Preview {
//    PlayerFaceView(imageSource: "", circleWidth: 100, circleHeight: 100)
//}
