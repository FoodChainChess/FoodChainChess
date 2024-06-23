import SwiftUI

struct ProfilePictureView: View {
    @State private var image = UIImage(named: "defaultAvatarPicture")!
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(100)
                .onTapGesture {
                    self.showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    ImagePicker(selectedImage: self.$image, sourceType: .camera)
                }
        }
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}
