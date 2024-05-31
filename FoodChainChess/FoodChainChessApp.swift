import SwiftUI

@main
struct FoodChainChessApp: App {
    @StateObject private var languageSettings = LanguageSettings()
    @StateObject private var appearanceSettings = AppearanceSettings()
    @State private var rootViewID = UUID()
    
    var playerManager: PlayerManager = PlayerManager()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(languageSettings)
                .environmentObject(appearanceSettings)
                .environmentObject(playerManager)
                .preferredColorScheme(appearanceSettings.isDarkMode ? .dark : .light)
                .id(rootViewID)
        }
    }
}
