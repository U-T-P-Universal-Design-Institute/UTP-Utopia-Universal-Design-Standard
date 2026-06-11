import Foundation

enum MessageRole {
    case user
    case assistant
    case thinking
    case system
    case toolCall
}

struct ChatMessage: Identifiable, Hashable {
    let id: String
    let role: MessageRole
    var text: String
    let timestamp: Date
    var toolName: String?
    var toolStatus: String?
    var isStreaming: Bool

    init(
        id: String = UUID().uuidString,
        role: MessageRole,
        text: String,
        timestamp: Date = .now,
        toolName: String? = nil,
        toolStatus: String? = nil,
        isStreaming: Bool = false
    ) {
        self.id = id
        self.role = role
        self.text = text
        self.timestamp = timestamp
        self.toolName = toolName
        self.toolStatus = toolStatus
        self.isStreaming = isStreaming
    }
}

struct StreamEvent {
    enum EventType: String {
        case status
        case assistant
        case thinking
        case toolCall = "tool_call"
        case result
        case error
        case done
        case heartbeat
    }

    let type: EventType
    let eventId: String?
    let data: [String: Any]
}
