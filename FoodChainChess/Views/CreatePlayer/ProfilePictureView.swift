import SwiftUI

struct ProfilePictureView: View {
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        Image("defaultAvatarPicture")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .cornerRadius(100)
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .camera, selectedImage: self.$image)
            }
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}
