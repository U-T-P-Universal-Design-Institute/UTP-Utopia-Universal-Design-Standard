import Foundation

enum AgentStatus: String, Codable, CaseIterable {
    case active = "ACTIVE"
    case archived = "ARCHIVED"
}

struct AgentEnvironment: Codable, Hashable {
    let type: String
    let name: String?
}

struct AgentRepo: Codable, Hashable, Identifiable {
    var id: String { url }
    let url: String
    let startingRef: String?
    let prUrl: String?
}

struct Agent: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let status: AgentStatus
    let env: AgentEnvironment?
    let repos: [AgentRepo]?
    let workOnCurrentBranch: Bool?
    let autoCreatePR: Bool?
    let url: String?
    let createdAt: Date
    let updatedAt: Date
    let latestRunId: String?

    var repoDisplayName: String {
        guard let url = repos?.first?.url,
              let name = URL(string: url)?.pathComponents.last else {
            return "No repository"
        }
        return name
    }

    var branchDisplayName: String {
        repos?.first?.startingRef ?? "main"
    }
}

struct AgentListResponse: Codable {
    let items: [Agent]
    let nextCursor: String?
}

struct CreateAgentRequest: Encodable {
    struct Prompt: Encodable {
        let text: String
    }

    struct ModelSelection: Encodable {
        let id: String
    }

    struct RepoConfig: Encodable {
        let url: String
        let startingRef: String?
    }

    let prompt: Prompt
    let model: ModelSelection?
    let name: String?
    let repos: [RepoConfig]?
    let autoCreatePR: Bool?
    let mode: String?
}

struct CreateAgentResponse: Codable {
    let agent: Agent
    let run: AgentRun
}
