import SwiftUI

struct AgentsListView: View {
    var onNewAgent: () -> Void = {}
    @StateObject private var viewModel = AgentsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.agents.isEmpty && !viewModel.isLoading {
                    emptyState
                } else {
                    agentList
                }
            }
            .background(CursorTheme.surface)
            .navigationTitle("Agents")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onNewAgent) {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Task { await viewModel.loadAgents() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .refreshable {
                await viewModel.loadAgents()
            }
            .task {
                await viewModel.loadAgents()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Agents Yet", systemImage: "cpu")
        } description: {
            Text("Start a Cloud Agent to work on your repositories from your iPhone.")
        } actions: {
            Button("New Agent", action: onNewAgent)
            .buttonStyle(.borderedProminent)
            .tint(CursorTheme.accent)
        }
    }

    private var agentList: some View {
        List {
            ForEach(viewModel.agents) { agent in
                NavigationLink(value: agent) {
                    AgentRowView(agent: agent)
                }
                .listRowBackground(CursorTheme.card)
                .task {
                    await viewModel.loadMoreIfNeeded(currentAgent: agent)
                }
            }

            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .navigationDestination(for: Agent.self) { agent in
            AgentDetailView(agentId: agent.id, agentName: agent.name)
        }
    }
}

struct AgentRowView: View {
    let agent: Agent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(agent.name)
                    .font(.headline)
                    .lineLimit(2)

                Spacer()

                StatusBadge(status: agent.status.rawValue, color: agent.status == .active ? CursorTheme.accent : .gray)
            }

            HStack(spacing: 6) {
                Image(systemName: "folder")
                    .font(.caption)
                Text(agent.repoDisplayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Text(agent.updatedAt, style: .relative)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: String
    let color: Color

    var body: some View {
        Text(status.capitalized)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
