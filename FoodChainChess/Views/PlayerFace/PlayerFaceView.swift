import SwiftUI

struct PlayerFaceView: View {
    var imageSource: UIImage // Use UIImage instead of String
    var circleWidth: CGFloat
    var circleHeight: CGFloat
    
    var body: some View {
        Image(uiImage: imageSource)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: circleWidth, height: circleHeight)
            .clipShape(Circle())
            .overlay(Circle().stroke(Colors.text))
    }
}

struct PlayerFaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerFaceView(imageSource: UIImage(named: "defaultPlayerImage")!, circleWidth: 50, circleHeight: 50)
    }
}
