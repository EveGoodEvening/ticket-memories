import SwiftUI
import SwiftData

struct TimelineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MemoryEvent.startDate, order: .reverse) private var memories: [MemoryEvent]
    @State private var showingCreateSheet = false
    @State private var showingImportSheet = false

    private struct YearGroup: Identifiable {
        let year: Int?
        let monthGroups: [MonthGroup]
        var id: Int { year ?? -1 }
    }

    private struct MonthGroup: Identifiable {
        let month: Int?
        let memories: [MemoryEvent]
        var id: Int { month ?? -1 }

        var monthName: String? {
            guard let month else { return nil }
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            return formatter.monthSymbols[month - 1]
        }
    }

    private var groupedByYearAndMonth: [YearGroup] {
        let calendar = Calendar.current

        let byYear = Dictionary(grouping: memories) { event -> Int? in
            guard let date = event.startDate else { return nil }
            return calendar.component(.year, from: date)
        }

        return byYear
            .sorted { ($0.key ?? 0) > ($1.key ?? 0) }
            .map { year, events in
                let byMonth = Dictionary(grouping: events) { event -> Int? in
                    guard let date = event.startDate else { return nil }
                    return calendar.component(.month, from: date)
                }
                let monthGroups = byMonth
                    .sorted { ($0.key ?? 0) > ($1.key ?? 0) }
                    .map { MonthGroup(month: $0.key, memories: $0.value) }
                return YearGroup(year: year, monthGroups: monthGroups)
            }
    }

    var body: some View {
        Group {
            if memories.isEmpty {
                TimelineEmptyView(
                    onCreateTapped: { showingCreateSheet = true },
                    onImportTapped: { showingImportSheet = true }
                )
            } else {
                timelineContent
            }
        }
        .navigationTitle(String(localized: "timeline.title", defaultValue: "Timeline"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingCreateSheet = true
                    } label: {
                        Label(String(localized: "timeline.action.create", defaultValue: "Create Memory"), systemImage: "plus")
                    }
                    Button {
                        showingImportSheet = true
                    } label: {
                        Label(String(localized: "timeline.action.import", defaultValue: "Import .pkpass"), systemImage: "doc.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            CreateMemoryView()
        }
        .sheet(isPresented: $showingImportSheet) {
            ImportPassView()
        }
    }

    private var timelineContent: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(groupedByYearAndMonth) { yearGroup in
                    Section {
                        ForEach(yearGroup.monthGroups) { monthGroup in
                            if let monthName = monthGroup.monthName {
                                monthHeader(monthName)
                            }
                            ForEach(monthGroup.memories) { event in
                                NavigationLink(value: event.id) {
                                    TimelineEventCard(event: event)
                                        .accessibilityLabel(accessibilityLabel(for: event))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } header: {
                        yearHeader(yearGroup.year)
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

    private func monthHeader(_ name: String) -> some View {
        HStack {
            Text(name)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.top, 4)
    }

    private func accessibilityLabel(for event: MemoryEvent) -> String {
        var parts: [String] = [event.title, event.category.displayName]
        if let date = event.startDate {
            parts.append(date.formatted(.dateTime.month().day().year()))
        }
        if let venue = event.venueName {
            parts.append(venue)
        }
        if event.isFavorite {
            parts.append("Favorite")
        }
        return parts.joined(separator: ", ")
    }
}
