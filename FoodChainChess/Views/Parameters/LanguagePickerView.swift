import SwiftUI

struct LanguagePickerView: View {
    
    @EnvironmentObject var languageSettings: LanguageSettings

    enum Language: String, CaseIterable, Identifiable {
        case english = "en"
        case portuguese = "pt-BR"
        case french = "fr"
        
        var id: Self { self }
        
        var displayName: String {
            switch self {
            case .english: return NSLocalizedString("English", tableName: "Localization", comment: "")
            case .portuguese: return NSLocalizedString("Portuguese", tableName: "Localization", comment: "")
            case .french: return NSLocalizedString("French", tableName: "Localization", comment: "")
            }
        }
    }

    
    var body: some View {
        HStack{
            Text("Language", tableName: "Localization")
            Spacer()
            Picker("Language", selection: $languageSettings.currentLanguage) {
                ForEach(Language.allCases) { language in
                    Text(language.displayName).tag(language.rawValue)
                }
            }
        }.padding(.horizontal, 60)
    }
}

struct LangagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePickerView().environmentObject(LanguageSettings())
    }
}
