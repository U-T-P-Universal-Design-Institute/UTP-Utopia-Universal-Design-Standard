import Foundation

@MainActor
final class AgentsViewModel: ObservableObject {
    @Published var agents: [Agent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var nextCursor: String?

    func loadAgents(refresh: Bool = true) async {
        if refresh {
            nextCursor = nil
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await CursorAPIService.shared.listAgents(
                limit: 30,
                cursor: refresh ? nil : nextCursor
            )

            if refresh {
                agents = response.items
            } else {
                agents.append(contentsOf: response.items)
            }
            nextCursor = response.nextCursor
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentAgent: Agent) async {
        guard let nextCursor,
              !isLoading,
              agents.last?.id == currentAgent.id else { return }
        await loadAgents(refresh: false)
    }
}
