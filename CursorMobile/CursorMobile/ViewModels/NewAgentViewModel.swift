import Foundation

@MainActor
final class NewAgentViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var selectedRepo: GitHubRepository?
    @Published var branch = "main"
    @Published var selectedModel: CursorModel?
    @Published var autoCreatePR = false
    @Published var mode: AgentMode = .agent

    @Published var repositories: [GitHubRepository] = []
    @Published var models: [CursorModel] = []

    @Published var isLoadingRepos = false
    @Published var isLoadingModels = false
    @Published var isCreating = false
    @Published var errorMessage: String?

    @Published var createdAgent: Agent?
    @Published var createdRun: AgentRun?

    enum AgentMode: String, CaseIterable, Identifiable {
        case agent = "agent"
        case plan = "plan"

        var id: String { rawValue }

        var title: String {
            switch self {
            case .agent: return "Agent"
            case .plan: return "Plan"
            }
        }

        var subtitle: String {
            switch self {
            case .agent: return "Implement changes directly"
            case .plan: return "Explore and draft a plan first"
            }
        }
    }

    func loadMetadata() async {
        async let reposTask: () = loadRepositories()
        async let modelsTask: () = loadModels()
        _ = await (reposTask, modelsTask)
    }

    func loadRepositories() async {
        isLoadingRepos = true
        do {
            let response = try await CursorAPIService.shared.listRepositories()
            repositories = response.items
            if selectedRepo == nil {
                selectedRepo = repositories.first
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingRepos = false
    }

    func loadModels() async {
        isLoadingModels = true
        do {
            let response = try await CursorAPIService.shared.listModels()
            models = response.items
            selectedModel = models.first
        } catch {
            // Models are optional — fall back to server default
        }
        isLoadingModels = false
    }

    func createAgent() async -> Bool {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Enter a task for the agent."
            return false
        }

        isCreating = true
        errorMessage = nil

        do {
            let response = try await CursorAPIService.shared.createAgent(
                prompt: trimmed,
                repoURL: selectedRepo?.url,
                branch: branch.isEmpty ? "main" : branch,
                modelId: selectedModel?.id,
                autoCreatePR: autoCreatePR,
                mode: mode.rawValue
            )
            createdAgent = response.agent
            createdRun = response.run
            isCreating = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isCreating = false
            return false
        }
    }

    func reset() {
        prompt = ""
        branch = "main"
        autoCreatePR = false
        mode = .agent
        createdAgent = nil
        createdRun = nil
        errorMessage = nil
    }
}
