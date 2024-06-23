import SwiftUI

struct ListItemScoreboardView: View {
    var body: some View {
        HStack {
            Text("1")
            Spacer()
            PlayerFaceView(imageSource: UIImage(named: "defaultAvatarPicture")!, circleWidth: 40, circleHeight: 40)
            Text("Username").TextStyle(BoldBodyTextStyle())
            Spacer()
            Text("V")
            Text("/")
            Text("D")
        }.padding()
    }
}

struct ListItemScorePreview_Previews: PreviewProvider {
    static var previews: some View {
        ListItemScoreboardView()
        
    }
}

//#Preview {
//    ListItemScoreboardView()(
//}
