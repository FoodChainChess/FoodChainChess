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
            HStack {
                Text(NSLocalizedString("🌎 Language", tableName: "Localization", comment: ""))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.leading, 20)
                Spacer()
                Picker("Language", selection: $languageSettings.currentLanguage) {
                    ForEach(Language.allCases) { language in
                        Text(language.displayName)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .tag(language.rawValue)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.background, lineWidth: 1)
                )
            }
            .padding()
            .background(Colors.backgroundbutton)
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
}

struct LangagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePickerView().environmentObject(LanguageSettings())
    }
}
