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
            case .english: return "English"
            case .portuguese: return "Portuguese (Brazil)"
            case .french: return "French"
            }
        }
    }

    
    var body: some View {
        HStack{
            Text("Language")
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
