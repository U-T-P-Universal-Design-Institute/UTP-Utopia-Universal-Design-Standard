import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var apiKey = ""
    @State private var isValidating = false
    @State private var errorMessage: String?
    @State private var userInfo: APIKeyInfo?
    @FocusState private var isKeyFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    header
                    features
                    apiKeySection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
            .background(CursorTheme.surface)
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(CursorTheme.accent.opacity(0.15))
                    .frame(width: 88, height: 88)
                Image(systemName: "cursorarrow.rays")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(CursorTheme.accent)
            }

            VStack(spacing: 8) {
                Text("Cursor Mobile")
                    .font(.largeTitle.bold())

                Text("Run Cloud Agents from your iPhone. Chat with AI, manage repos, and ship code on the go.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 16)
    }

    private var features: some View {
        VStack(spacing: 12) {
            FeatureRow(icon: "bubble.left.and.bubble.right.fill", title: "Agent Chat", subtitle: "Stream responses in real time")
            FeatureRow(icon: "folder.fill", title: "GitHub Repos", subtitle: "Work on your repositories in the cloud")
            FeatureRow(icon: "arrow.triangle.branch", title: "Pull Requests", subtitle: "Auto-create PRs when agents finish")
        }
    }

    private var apiKeySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Connect Your Account")
                    .font(.headline)

                Text("Get your API key from [Cursor Dashboard → API Keys](https://cursor.com/settings). Your key is stored securely in the iOS Keychain.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            SecureField("Paste your Cursor API key", text: $apiKey)
                .textContentType(.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($isKeyFieldFocused)
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            if let userInfo {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(userInfo.displayName)
                            .font(.subheadline.weight(.medium))
                        Text(userInfo.apiKeyName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            Button(action: connect) {
                HStack {
                    if isValidating {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(userInfo == nil ? "Connect" : "Continue")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .tint(CursorTheme.accent)
            .disabled(apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isValidating)
        }
        .cursorCard()
    }

    private func connect() {
        let trimmed = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isValidating = true
        errorMessage = nil
        isKeyFieldFocused = false

        Task {
            do {
                try KeychainService.shared.saveAPIKey(trimmed)
                let info = try await CursorAPIService.shared.validateAPIKey()
                userInfo = info
                try await Task.sleep(for: .milliseconds(600))
                appState.isAuthenticated = true
            } catch {
                KeychainService.shared.deleteAPIKey()
                errorMessage = error.localizedDescription
            }
            isValidating = false
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(CursorTheme.accent)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
