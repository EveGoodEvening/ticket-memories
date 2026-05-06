import SwiftUI
import SwiftData

@main
struct TicketMemoriesApp: App {
    var body: some Scene {
        WindowGroup {
            AppRouter()
        }
        .modelContainer(for: [
            MemoryEvent.self,
            PassSnapshot.self,
            MediaAsset.self,
            SpotifyPlaylistLink.self,
            AnnualRecap.self,
            ExportArtifact.self,
        ])
    }
}
