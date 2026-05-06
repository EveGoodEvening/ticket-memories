import SwiftUI

struct AppRouter: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab: AppTab = .timeline

    var body: some View {
        if hasCompletedOnboarding {
            mainTabs
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }

    private var mainTabs: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.timeline.title, systemImage: AppTab.timeline.iconName, value: .timeline) {
                NavigationStack {
                    TimelineView()
                }
            }

            Tab(AppTab.map.title, systemImage: AppTab.map.iconName, value: .map) {
                NavigationStack {
                    MemoryMapView()
                }
            }

            Tab(AppTab.recap.title, systemImage: AppTab.recap.iconName, value: .recap) {
                NavigationStack {
                    RecapView()
                }
            }

            Tab(AppTab.settings.title, systemImage: AppTab.settings.iconName, value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
    }
}

enum AppTab: String, CaseIterable {
    case timeline
    case map
    case recap
    case settings

    var title: String {
        switch self {
        case .timeline: String(localized: "tab.timeline", defaultValue: "Timeline")
        case .map: String(localized: "tab.map", defaultValue: "Map")
        case .recap: String(localized: "tab.recap", defaultValue: "Recap")
        case .settings: String(localized: "tab.settings", defaultValue: "Settings")
        }
    }

    var iconName: String {
        switch self {
        case .timeline: "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case .map: "map"
        case .recap: "star.square.on.square"
        case .settings: "gearshape"
        }
    }
}

#Preview {
    AppRouter()
        .modelContainer(for: MemoryEvent.self, inMemory: true)
}
