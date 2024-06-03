import SwiftUI

struct ParametersView: View {
    
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: NSLocalizedString("Parameters", tableName: "Localization", comment: ""))
            ModeSwitchView()
                .padding(.top, 60)
            LanguagePickerView()
                .padding(.top, 30)
            Spacer()
        }.background(Colors.background)
    }
}

struct ParametersView_Previews: PreviewProvider {
    static var previews: some View {
        ParametersView()            .environmentObject(LanguageSettings())
            .environmentObject(AppearanceSettings())
    }
}
