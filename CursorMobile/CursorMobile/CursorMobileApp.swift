import SwiftUI

@main
struct CursorMobileApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.preferredColorScheme)
        }
    }
}

final class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var preferredColorScheme: ColorScheme? = nil

    init() {
        isAuthenticated = KeychainService.shared.hasAPIKey
    }
}

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if appState.isAuthenticated {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.isAuthenticated)
    }
}
