import SwiftUI

struct ModeSwitchView: View {
    
    @EnvironmentObject var appearanceSettings: AppearanceSettings

    var body: some View {
        VStack{
            Toggle(isOn: $appearanceSettings.isDarkMode) {
                Text("Dark Mode")
            }
            .padding(.horizontal, 60)
        }
    }
}

struct ModeSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSwitchView()
    }
}
