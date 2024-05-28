import SwiftUI

@main
struct FoodChainChessApp: App {
    @StateObject private var languageSettings = LanguageSettings()
    @StateObject private var appearanceSettings = AppearanceSettings()
    @State private var rootViewID = UUID()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(languageSettings)
                .environmentObject(appearanceSettings)
                .preferredColorScheme(appearanceSettings.isDarkMode ? .dark : .light)
                .id(rootViewID)
        }
    }
}
