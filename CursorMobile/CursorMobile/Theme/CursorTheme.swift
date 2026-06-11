import SwiftUI

enum CursorTheme {
    static let accent = Color(red: 0.42, green: 0.78, blue: 0.47)
    static let accentDark = Color(red: 0.32, green: 0.68, blue: 0.38)
    static let surface = Color(.systemGroupedBackground)
    static let card = Color(.secondarySystemGroupedBackground)
    static let userBubble = Color(red: 0.18, green: 0.18, blue: 0.20)
    static let assistantBubble = Color(.tertiarySystemGroupedBackground)

    static let statusRunning = Color.orange
    static let statusFinished = Color.green
    static let statusError = Color.red
    static let statusCreating = Color.blue

    static func statusColor(for status: RunStatus) -> Color {
        switch status {
        case .creating: return statusCreating
        case .running: return statusRunning
        case .finished: return statusFinished
        case .error, .expired: return statusError
        case .cancelled: return .gray
        }
    }
}

struct CursorCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(CursorTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

extension View {
    func cursorCard() -> some View {
        modifier(CursorCardStyle())
    }
}
