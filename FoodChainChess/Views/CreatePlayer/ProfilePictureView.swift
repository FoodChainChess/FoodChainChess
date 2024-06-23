import SwiftUI

struct ProfilePictureView: View {
    @Binding var selectedImage: UIImage
    @State private var showCamera = false
    
    var body: some View {
        VStack {
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(100)
                .onTapGesture {
                    self.showCamera = true
                }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(selectedImage: .constant(UIImage(named: "defaultAvatarPicture")!))
    }
}
