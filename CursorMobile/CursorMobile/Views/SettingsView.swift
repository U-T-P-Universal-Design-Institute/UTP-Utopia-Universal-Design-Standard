import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var userInfo: APIKeyInfo?
    @State private var isLoading = true
    @State private var showSignOutConfirm = false
    @State private var appearance: AppearanceMode = .system

    enum AppearanceMode: String, CaseIterable, Identifiable {
        case system, light, dark
        var id: String { rawValue }

        var title: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }

        var colorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                accountSection
                appearanceSection
                aboutSection
            }
            .navigationTitle("Settings")
            .task {
                await loadUserInfo()
            }
            .confirmationDialog("Sign Out?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
                Button("Sign Out", role: .destructive) {
                    signOut()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Your API key will be removed from this device.")
            }
        }
    }

    private var accountSection: some View {
        Section("Account") {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("Loading…")
                }
            } else if let userInfo {
                LabeledContent("Name", value: userInfo.displayName)
                if let email = userInfo.userEmail {
                    LabeledContent("Email", value: email)
                }
                LabeledContent("API Key", value: userInfo.apiKeyName)
            }

            Button("Sign Out", role: .destructive) {
                showSignOutConfirm = true
            }
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $appearance) {
                ForEach(AppearanceMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .onChange(of: appearance) { _, newValue in
                appState.preferredColorScheme = newValue.colorScheme
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            LabeledContent("Version", value: "1.0.0")

            if let url = URL(string: "https://cursor.com/docs/cloud-agent/api/endpoints") {
                Link("Cloud Agents API Docs", destination: url)
            }

            if let url = URL(string: "https://cursor.com/settings") {
                Link("Cursor Dashboard", destination: url)
            }
        }
    }

    private func loadUserInfo() async {
        isLoading = true
        userInfo = try? await CursorAPIService.shared.validateAPIKey()
        isLoading = false
    }

    private func signOut() {
        KeychainService.shared.deleteAPIKey()
        appState.isAuthenticated = false
    }
}
