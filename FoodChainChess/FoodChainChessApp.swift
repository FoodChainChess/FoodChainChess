import SwiftUI

@main
struct FoodChainChessApp: App {
    @StateObject private var languageSettings = LanguageSettings()
    @State private var rootViewID = UUID()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(languageSettings)
                .id(rootViewID)
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LanguageChanged"))) { _ in
                    rootViewID = UUID()
                }
        }
    }
}
