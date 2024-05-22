import SwiftUI

struct LanguagePickerView: View {
    
    @State private var selectedLanguage: Language = .english
    
    enum Language: String, CaseIterable, Identifiable {
        case english, portuguese, french
        var id: Self { self }
    }

    
    var body: some View {
        HStack{
            Text("Language :")
            Spacer()
            Picker("Language", selection: $selectedLanguage) {
                Text("English").tag(Language.english)
                Text("Portuguese").tag(Language.french)
                Text("French").tag(Language.portuguese)
            }
        }.padding(.horizontal, 60)
    }
}

struct LangagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePickerView()
    }
}
