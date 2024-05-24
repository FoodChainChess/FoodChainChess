import SwiftUI

struct PlayerFaceView: View {
    var imageSource: String = "" // TODO: default player image
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

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        PlayerFaceView(imageSource: "", circleWidth: 50, circleHeight: 50)
    }
}
//#Preview {
//    PlayerFaceView(imageSource: "", circleWidth: 100, circleHeight: 100)
//}
