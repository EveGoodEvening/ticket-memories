import SwiftUI
import SwiftData

struct RecapView: View {
    @Query private var memories: [MemoryEvent]

    var body: some View {
        Group {
            if memories.isEmpty {
                ContentUnavailableView {
                    Label(
                        String(localized: "recap.empty.title", defaultValue: "No Recaps Yet"),
                        systemImage: "star.square.on.square"
                    )
                } description: {
                    Text(String(localized: "recap.empty.description",
                                 defaultValue: "Create some memories first, then generate a beautiful annual recap."))
                }
            } else {
                Text(String(localized: "recap.placeholder", defaultValue: "Recap coming soon"))
            }
        }
        .navigationTitle(String(localized: "recap.title", defaultValue: "Recap"))
    }
}
