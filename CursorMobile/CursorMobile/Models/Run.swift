import Foundation

enum RunStatus: String, Codable, CaseIterable {
    case creating = "CREATING"
    case running = "RUNNING"
    case finished = "FINISHED"
    case error = "ERROR"
    case cancelled = "CANCELLED"
    case expired = "EXPIRED"

    var displayName: String {
        switch self {
        case .creating: return "Starting"
        case .running: return "Running"
        case .finished: return "Done"
        case .error: return "Error"
        case .cancelled: return "Cancelled"
        case .expired: return "Expired"
        }
    }

    var isTerminal: Bool {
        switch self {
        case .finished, .error, .cancelled, .expired: return true
        default: return false
        }
    }
}

struct GitBranch: Codable, Hashable, Identifiable {
    var id: String { "\(repoUrl)-\(branch ?? "")" }
    let repoUrl: String
    let branch: String?
    let prUrl: String?
}

struct GitInfo: Codable, Hashable {
    let branches: [GitBranch]
}

struct AgentRun: Codable, Identifiable, Hashable {
    let id: String
    let agentId: String
    let status: RunStatus
    let createdAt: Date
    let updatedAt: Date
    let durationMs: Int?
    let result: String?
    let git: GitInfo?
}

struct RunListResponse: Codable {
    let items: [AgentRun]
    let nextCursor: String?
}

struct CreateRunRequest: Encodable {
    struct Prompt: Encodable {
        let text: String
    }

    let prompt: Prompt
    let mode: String?
}

struct CreateRunResponse: Codable {
    let run: AgentRun
}

struct TokenUsage: Codable, Hashable {
    let inputTokens: Int
    let outputTokens: Int
    let cacheWriteTokens: Int
    let cacheReadTokens: Int
    let totalTokens: Int
}

struct RunUsage: Codable, Identifiable {
    let id: String
    let usageUuid: String?
    let usage: TokenUsage
}

struct AgentUsageResponse: Codable {
    let totalUsage: TokenUsage
    let runs: [RunUsage]
}
