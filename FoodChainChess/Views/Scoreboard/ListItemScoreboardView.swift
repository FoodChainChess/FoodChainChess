import SwiftUI
import DouShouQiModel

struct ListItemScoreboardView: View {
    let player: Player
    let index: Int
    var playerManager: PlayerManager = PlayerManager.shared
    
    var body: some View {
            HStack {
                Text("\(index + 1)")
                    .padding(.leading)
                
                PlayerFaceView(imageSource: playerManager.getAvatarImage(for: player.name), circleWidth: 40, circleHeight: 40)
                
                Text(player.name)
                    .TextStyle(BoldBodyTextStyle())
                
                Spacer()
                
                Text("V")
                Text("/")
                Text("D")
            }
        }
}

//struct ListItemScorePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ListItemScoreboardView()
//        
//    }
//}

//#Preview {
//    ListItemScoreboardView()(
//}
