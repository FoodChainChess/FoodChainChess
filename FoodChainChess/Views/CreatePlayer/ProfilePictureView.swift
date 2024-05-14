import SwiftUI

struct ProfilePictureView: View {
    var body: some View {
        Image("defaultAvatarPicture")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .cornerRadius(100)
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}
