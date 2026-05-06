import SwiftUI
import SwiftData

struct MemoryMapView: View {
    @Query private var memories: [MemoryEvent]

    private var locatedMemories: [MemoryEvent] {
        memories.filter { $0.hasCoordinates }
    }

    var body: some View {
        Group {
            if locatedMemories.isEmpty {
                ContentUnavailableView {
                    Label(
                        String(localized: "map.empty.title", defaultValue: "No Locations Yet"),
                        systemImage: "map"
                    )
                } description: {
                    Text(String(localized: "map.empty.description",
                                 defaultValue: "Add locations to your memories to see them on the map."))
                }
            } else {
                Text(String(localized: "map.placeholder", defaultValue: "Map coming soon"))
            }
        }
        .navigationTitle(String(localized: "map.title", defaultValue: "Map"))
    }
}
