import SwiftUI

struct ListItemScoreboardView: View {
    var body: some View {
        HStack {
            Text("1")
            Spacer()
            PlayerFaceView(imageSource: "", circleWidth: 40, circleHeight: 40)
            Text("Username")
            Spacer()
            Text("V")
            Text("/")
            Text("D")
        }.padding()
    }
}
struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ListItemScoreboardView()
    }
}

//#Preview {
//    ListItemScoreboardView()(
//}
