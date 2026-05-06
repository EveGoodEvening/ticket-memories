import SwiftUI
import SwiftData

struct TimelineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MemoryEvent.startDate, order: .reverse) private var memories: [MemoryEvent]
    @State private var showingCreateSheet = false

    private var groupedByYear: [(year: Int?, memories: [MemoryEvent])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: memories) { event -> Int? in
            guard let date = event.startDate else { return nil }
            return calendar.component(.year, from: date)
        }
        return grouped
            .sorted { ($0.key ?? 0) > ($1.key ?? 0) }
            .map { (year: $0.key, memories: $0.value) }
    }

    var body: some View {
        Group {
            if memories.isEmpty {
                TimelineEmptyView(onCreateTapped: { showingCreateSheet = true })
            } else {
                timelineContent
            }
        }
        .navigationTitle(String(localized: "timeline.title", defaultValue: "Timeline"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            CreateMemoryView()
        }
    }

    private var timelineContent: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(groupedByYear, id: \.year) { group in
                    Section {
                        ForEach(group.memories) { event in
                            NavigationLink(value: event.id) {
                                TimelineEventCard(event: event)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        yearHeader(group.year)
                    }
                }
            }
            .padding()
        }
        .navigationDestination(for: UUID.self) { eventId in
            if let event = memories.first(where: { $0.id == eventId }) {
                MemoryDetailView(event: event)
            }
        }
    }

    private func yearHeader(_ year: Int?) -> some View {
        HStack {
            Text(year.map { String($0) } ?? String(localized: "timeline.unknownDate", defaultValue: "Unknown Date"))
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)
            Spacer()
        }
        .padding(.top, 8)
    }
}
