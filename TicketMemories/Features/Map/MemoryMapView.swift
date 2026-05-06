import SwiftUI
import SwiftData
import MapKit

struct MemoryMapView: View {
    @Query private var memories: [MemoryEvent]
    @State private var selectedEventId: UUID?
    @State private var yearFilter: Int?
    @State private var categoryFilter: EventCategory?
    @State private var position: MapCameraPosition = .automatic

    private var locatedMemories: [MemoryEvent] {
        memories.filter { $0.hasCoordinates }
    }

    private var filteredMemories: [MemoryEvent] {
        locatedMemories.filter { event in
            if let year = yearFilter, let date = event.startDate {
                let eventYear = Calendar.current.component(.year, from: date)
                guard eventYear == year else { return false }
            }
            if let category = categoryFilter {
                guard event.category == category else { return false }
            }
            return true
        }
    }

    private var availableYears: [Int] {
        let years = Set(locatedMemories.compactMap { event -> Int? in
            guard let date = event.startDate else { return nil }
            return Calendar.current.component(.year, from: date)
        })
        return years.sorted(by: >)
    }

    private var selectedEvent: MemoryEvent? {
        guard let id = selectedEventId else { return nil }
        return memories.first { $0.id == id }
    }

    var body: some View {
        Group {
            if locatedMemories.isEmpty {
                mapEmptyView
            } else {
                mapContent
            }
        }
        .navigationTitle(String(localized: "map.title", defaultValue: "Map"))
    }

    private var mapEmptyView: some View {
        ContentUnavailableView {
            Label(
                String(localized: "map.empty.title", defaultValue: "No Locations Yet"),
                systemImage: "map"
            )
        } description: {
            Text(String(localized: "map.empty.description",
                         defaultValue: "Add locations to your memories to see them on the map."))
        }
    }

    private var mapContent: some View {
        ZStack(alignment: .top) {
            Map(position: $position, selection: $selectedEventId) {
                ForEach(filteredMemories) { event in
                    if let lat = event.latitude, let lon = event.longitude {
                        Marker(
                            event.title,
                            systemImage: event.category.iconName,
                            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        )
                        .tint(event.category.color)
                        .tag(event.id)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))

            filterBar

            if let event = selectedEvent {
                VStack {
                    Spacer()
                    MapEventPreviewCard(event: event)
                        .padding()
                }
            }
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Menu {
                    Button(String(localized: "map.filter.allYears", defaultValue: "All Years")) {
                        yearFilter = nil
                    }
                    ForEach(availableYears, id: \.self) { year in
                        Button(String(year)) { yearFilter = year }
                    }
                } label: {
                    filterChip(
                        title: yearFilter.map { String($0) } ?? String(localized: "map.filter.year", defaultValue: "Year"),
                        isActive: yearFilter != nil
                    )
                }

                Menu {
                    Button(String(localized: "map.filter.allCategories", defaultValue: "All Categories")) {
                        categoryFilter = nil
                    }
                    ForEach(EventCategory.allCases) { cat in
                        Button {
                            categoryFilter = cat
                        } label: {
                            Label(cat.displayName, systemImage: cat.iconName)
                        }
                    }
                } label: {
                    filterChip(
                        title: categoryFilter?.displayName ?? String(localized: "map.filter.category", defaultValue: "Category"),
                        isActive: categoryFilter != nil
                    )
                }

                if yearFilter != nil || categoryFilter != nil {
                    Button {
                        yearFilter = nil
                        categoryFilter = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }

    private func filterChip(title: String, isActive: Bool) -> some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isActive ? Color.accentColor.opacity(0.15) : Color(.systemBackground), in: Capsule())
            .overlay(Capsule().stroke(isActive ? Color.accentColor : Color.secondary.opacity(0.3)))
    }
}

struct MapEventPreviewCard: View {
    let event: MemoryEvent

    var body: some View {
        NavigationLink(value: event.id) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(event.category.color.gradient)
                        .frame(width: 56, height: 56)
                    Image(systemName: event.category.iconName)
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.headline)
                        .lineLimit(1)
                    if let date = event.startDate {
                        Text(date.formatted(.dateTime.month(.abbreviated).day().year()))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    if let venue = event.venueName ?? event.city {
                        Text(venue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}
