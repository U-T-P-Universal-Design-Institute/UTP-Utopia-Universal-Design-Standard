import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AgentsListView(onNewAgent: { selectedTab = 1 })
                .tabItem {
                    Label("Agents", systemImage: "cpu")
                }
                .tag(0)

            NewAgentView(onCreated: {
                selectedTab = 0
            })
            .tabItem {
                Label("New", systemImage: "plus.circle.fill")
            }
            .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .tint(CursorTheme.accent)
    }
}
