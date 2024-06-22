import SwiftUI

struct CreatePlayerView: View {
    @State private var name = ""
    @State private var errorMessage = ""
    
    @State private var isShowingConfirmation = false
    
    var playerManager = PlayerManager.shared
    
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
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            VStack {
                MainButtonView(buttonText: "Create", color: Colors.primary) {
                    if let error = playerManager.addNewPlayer(username: name) {
                        errorMessage = error
                    } else {
                        self.isShowingConfirmation = true
                        errorMessage = ""
                        print("Player count: \(playerManager.createdPlayers.count)")
                    }
                }
                .alert(isPresented: $isShowingConfirmation) {
                    Alert(
                        title: Text("New player created.", tableName: "Localization"),
                        message: Text("Player \(name) was created.", tableName: "Localization"),

                        dismissButton: .default(
                            Text("Ok", tableName: "Localization"),
                            action: {
                                self.name = ""
                            }
                        ))
                }
            }.padding(60)
            Spacer()
        }.background(Colors.background)
    }
}

struct CreatePlayerView_Previews: PreviewProvider {
    static var previews: some View {
    
        CreatePlayerView()
    }
}
