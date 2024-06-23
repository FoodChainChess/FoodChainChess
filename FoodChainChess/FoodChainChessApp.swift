import SwiftUI

@main
struct FoodChainChessApp: App {
    
    
    @StateObject private var languageSettings = LanguageSettings()
    @StateObject private var appearanceSettings = AppearanceSettings()
    
    @StateObject private var gameSceneManager = GameSceneManager()

    @State private var rootViewID = UUID()
    

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(languageSettings)
                .environmentObject(appearanceSettings)
                .environmentObject(gameSceneManager)
                .preferredColorScheme(appearanceSettings.isDarkMode ? .dark : .light)
                .id(rootViewID)
        }
    }
}
