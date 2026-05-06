import SwiftUI

struct TimelineEmptyView: View {
    var onCreateTapped: () -> Void
    var onImportTapped: (() -> Void)?

    var body: some View {
        ContentUnavailableView {
            Label(
                String(localized: "timeline.empty.title", defaultValue: "No Memories Yet"),
                systemImage: "ticket"
            )
        } description: {
            Text(String(localized: "timeline.empty.description",
                         defaultValue: "Ticket Memories turns your event tickets into a personal timeline. Create your first memory or import a .pkpass file to get started."))
        } actions: {
            VStack(spacing: 12) {
                Button {
                    onCreateTapped()
                } label: {
                    Label(
                        String(localized: "timeline.empty.create", defaultValue: "Create Memory"),
                        systemImage: "plus"
                    )
                }
                .buttonStyle(.borderedProminent)

                if let onImportTapped {
                    Button {
                        onImportTapped()
                    } label: {
                        Label(
                            String(localized: "timeline.empty.import", defaultValue: "Import .pkpass"),
                            systemImage: "doc.badge.plus"
                        )
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
