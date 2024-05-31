import SwiftUI

struct CreatePlayerView: View {
    @State private var name = ""
    @EnvironmentObject var playerManager: PlayerManager

    
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: NSLocalizedString("New Player", tableName: "Localization", comment: ""))
            Spacer()
            ProfilePictureView()
            TextField(NSLocalizedString("Enter your name", tableName: "Localization", comment: ""), text: $name)
                .textFieldStyle(.plain)
                .padding(10)
                .background(Colors.backgroundbutton)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal, 60) // Changer la taille lateral
                .padding(.top, 50)
            VStack {
                MainButtonView(buttonText: "Create", color: Colors.primary) {
                    self.playerManager.addPlayer(username: name)
                    name = ""
                    print("Player count: \(self.playerManager.createdPlayers.count)")
                }
            }.padding(60)
            Spacer()
        }.background(Colors.background)
        
        
    }
}

struct CreatePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlayerView().environmentObject(PlayerManager())
    }
}
