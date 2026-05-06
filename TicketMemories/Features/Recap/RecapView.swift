import SwiftUI
import SwiftData

struct RecapView: View {
    @Query private var memories: [MemoryEvent]
    @State private var selectedYear: Int?

    private var availableYears: [Int] {
        RecapGenerator.availableYears(from: memories)
    }

    var body: some View {
        Group {
            if memories.isEmpty {
                recapEmptyView
            } else if availableYears.isEmpty {
                noYearDataView
            } else {
                recapContent
            }
        }
        .navigationTitle(String(localized: "recap.title", defaultValue: "Recap"))
        .onAppear {
            if selectedYear == nil {
                selectedYear = availableYears.first
            }
        }
    }

    private var recapEmptyView: some View {
        ContentUnavailableView {
            Label(
                String(localized: "recap.empty.title", defaultValue: "No Recaps Yet"),
                systemImage: "star.square.on.square"
            )
        } description: {
            Text(String(localized: "recap.empty.description",
                         defaultValue: "Create some memories first, then generate a beautiful annual recap."))
        }
    }

    private var noYearDataView: some View {
        ContentUnavailableView {
            Label(
                String(localized: "recap.noYear.title", defaultValue: "No Dated Events"),
                systemImage: "calendar.badge.exclamationmark"
            )
        } description: {
            Text(String(localized: "recap.noYear.description",
                         defaultValue: "Add dates to your memories to generate annual recaps."))
        }
    }

    private var recapContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                yearPicker

                if let year = selectedYear {
                    let stats = RecapGenerator.generateStats(for: memories, year: year)
                    let highlights = RecapGenerator.highlightEvents(from: memories, year: year)
                    let yearEvents = memories.filter { event in
                        guard let date = event.startDate else { return false }
                        return Calendar.current.component(.year, from: date) == year
                    }.sorted { ($0.startDate ?? .distantPast) < ($1.startDate ?? .distantPast) }

                    RecapStatsCard(year: year, stats: stats)
                    RecapHighlightsCard(highlights: highlights)

                    RecapExportButtons(
                        year: year,
                        stats: stats,
                        highlights: highlights,
                        allEvents: yearEvents
                    )
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .padding()
        }
    }

    private var yearPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(availableYears, id: \.self) { year in
                    Button {
                        selectedYear = year
                    } label: {
                        Text(String(year))
                            .font(.headline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                selectedYear == year ? Color.accentColor : Color(.secondarySystemBackground),
                                in: Capsule()
                            )
                            .foregroundStyle(selectedYear == year ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct RecapStatsCard: View {
    let year: Int
    let stats: RecapStats

    var body: some View {
        VStack(spacing: 20) {
            Text(String(localized: "recap.yearTitle \(year)", defaultValue: "\(year) Recap"))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
            ], spacing: 16) {
                statTile(
                    value: "\(stats.totalEvents)",
                    label: String(localized: "recap.stat.events", defaultValue: "Events")
                )
                statTile(
                    value: "\(stats.totalCities)",
                    label: String(localized: "recap.stat.cities", defaultValue: "Cities")
                )
                statTile(
                    value: "\(stats.totalCountries)",
                    label: String(localized: "recap.stat.countries", defaultValue: "Countries")
                )
                statTile(
                    value: "\(stats.highlightMediaCount)",
                    label: String(localized: "recap.stat.photos", defaultValue: "Photos")
                )
            }

            if let favoriteCity = stats.favoriteCity {
                statRow(
                    icon: "building.2",
                    label: String(localized: "recap.stat.favoriteCity", defaultValue: "Favorite City"),
                    value: favoriteCity
                )
            }

            if let favoriteVenue = stats.favoriteVenue {
                statRow(
                    icon: "mappin",
                    label: String(localized: "recap.stat.favoriteVenue", defaultValue: "Favorite Venue"),
                    value: favoriteVenue
                )
            }

            if let firstTitle = stats.firstEventTitle, let firstDate = stats.firstEventDate {
                statRow(
                    icon: "arrow.right.circle",
                    label: String(localized: "recap.stat.firstEvent", defaultValue: "First Event"),
                    value: "\(firstTitle) — \(firstDate.formatted(.dateTime.month(.abbreviated).day()))"
                )
            }

            if let lastTitle = stats.lastEventTitle, let lastDate = stats.lastEventDate {
                statRow(
                    icon: "arrow.left.circle",
                    label: String(localized: "recap.stat.lastEvent", defaultValue: "Last Event"),
                    value: "\(lastTitle) — \(lastDate.formatted(.dateTime.month(.abbreviated).day()))"
                )
            }

            if !stats.categoryDistribution.isEmpty {
                categoryBreakdown
            }
        }
        .padding(24)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20))
    }

    private func statTile(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title, design: .rounded, weight: .bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private func statRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.secondary)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
                .lineLimit(1)
        }
    }

    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "recap.stat.categories", defaultValue: "Categories"))
                .font(.subheadline.weight(.semibold))

            ForEach(stats.categoryDistribution.sorted(by: { $0.value > $1.value }), id: \.key) { key, count in
                if let category = EventCategory(rawValue: key) {
                    HStack {
                        Image(systemName: category.iconName)
                            .foregroundStyle(category.color)
                            .frame(width: 20)
                        Text(category.displayName)
                            .font(.subheadline)
                        Spacer()
                        Text("\(count)")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct RecapHighlightsCard: View {
    let highlights: [MemoryEvent]

    var body: some View {
        if !highlights.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(String(localized: "recap.highlights.title", defaultValue: "Highlights"))
                    .font(.headline)

                ForEach(highlights) { event in
                    NavigationLink(value: event.id) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(event.category.color.gradient)
                                    .frame(width: 44, height: 44)
                                Image(systemName: event.category.iconName)
                                    .foregroundStyle(.white)
                                    .font(.caption)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(.subheadline.weight(.medium))
                                    .lineLimit(1)
                                if let date = event.startDate {
                                    Text(date.formatted(.dateTime.month(.abbreviated).day()))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            if event.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                                    .font(.caption)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
