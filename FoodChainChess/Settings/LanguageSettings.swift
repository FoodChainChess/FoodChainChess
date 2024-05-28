import Foundation

class LanguageSettings: ObservableObject {
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }

    init() {
        self.currentLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
    }
}
