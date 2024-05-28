import SwiftUI

struct CreatePlayerView: View {
    @State private var name = ""

    
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "New Player")
            Spacer()
            ProfilePictureView()
            TextField("Enter your name", text: $name)
                .textFieldStyle(.plain)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal, 60) // Changer la taille lateral
                .padding(.top, 50)
            VStack {
                MainButtonView(buttonText: "Create", color: .secondary)
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
