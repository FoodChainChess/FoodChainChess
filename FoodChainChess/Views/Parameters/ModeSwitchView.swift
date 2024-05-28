import SwiftUI

struct ModeSwitchView: View {
    
    @EnvironmentObject var appearanceSettings: AppearanceSettings

    var body: some View {
        VStack{
            Toggle(isOn: $appearanceSettings.isDarkMode) {
                Text("🌗 Dark Mode", tableName: "Localization")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.leading, 20)
            }            
        }
        .padding()
        .background(Colors.backgroundbutton)
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

struct ModeSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSwitchView().environmentObject(AppearanceSettings())
    }
}
