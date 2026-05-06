import Foundation
import SwiftData

struct RecapStats: Codable {
    var totalEvents: Int
    var totalCities: Int
    var totalCountries: Int
    var categoryDistribution: [String: Int]
    var favoriteCity: String?
    var favoriteVenue: String?
    var firstEventTitle: String?
    var firstEventDate: Date?
    var lastEventTitle: String?
    var lastEventDate: Date?
    var minLatitude: Double?
    var maxLatitude: Double?
    var minLongitude: Double?
    var maxLongitude: Double?
    var highlightMediaCount: Int
}

struct RecapGenerator {
    static func generateStats(for memories: [MemoryEvent], year: Int) -> RecapStats {
        let calendar = Calendar.current
        let yearMemories = memories.filter { event in
            guard let date = event.startDate else { return false }
            return calendar.component(.year, from: date) == year
        }

        let sortedByDate = yearMemories
            .filter { $0.startDate != nil }
            .sorted { $0.startDate! < $1.startDate! }

        let cities = yearMemories.compactMap { $0.city }.filter { !$0.isEmpty }
        let countries = yearMemories.compactMap { $0.country }.filter { !$0.isEmpty }
        let venues = yearMemories.compactMap { $0.venueName }.filter { !$0.isEmpty }

        let categoryCounts = Dictionary(grouping: yearMemories, by: { $0.category.rawValue })
            .mapValues { $0.count }

        let cityCounts = Dictionary(grouping: cities, by: { $0 }).mapValues { $0.count }
        let venueCounts = Dictionary(grouping: venues, by: { $0 }).mapValues { $0.count }

        let locatedEvents = yearMemories.filter { $0.hasCoordinates }

        let mediaCount = yearMemories.reduce(0) { $0 + $1.mediaAssets.count }

        return RecapStats(
            totalEvents: yearMemories.count,
            totalCities: Set(cities).count,
            totalCountries: Set(countries).count,
            categoryDistribution: categoryCounts,
            favoriteCity: cityCounts.max(by: { $0.value < $1.value })?.key,
            favoriteVenue: venueCounts.max(by: { $0.value < $1.value })?.key,
            firstEventTitle: sortedByDate.first?.title,
            firstEventDate: sortedByDate.first?.startDate,
            lastEventTitle: sortedByDate.last?.title,
            lastEventDate: sortedByDate.last?.startDate,
            minLatitude: locatedEvents.compactMap { $0.latitude }.min(),
            maxLatitude: locatedEvents.compactMap { $0.latitude }.max(),
            minLongitude: locatedEvents.compactMap { $0.longitude }.min(),
            maxLongitude: locatedEvents.compactMap { $0.longitude }.max(),
            highlightMediaCount: mediaCount
        )
    }

    static func availableYears(from memories: [MemoryEvent]) -> [Int] {
        let calendar = Calendar.current
        let years = Set(memories.compactMap { event -> Int? in
            guard let date = event.startDate else { return nil }
            return calendar.component(.year, from: date)
        })
        return years.sorted(by: >)
    }

    static func highlightEvents(from memories: [MemoryEvent], year: Int, limit: Int = 6) -> [MemoryEvent] {
        let calendar = Calendar.current
        let yearMemories = memories.filter { event in
            guard let date = event.startDate else { return false }
            return calendar.component(.year, from: date) == year
        }

        let sorted = yearMemories.sorted { a, b in
            if a.isFavorite != b.isFavorite { return a.isFavorite }
            if a.mediaAssets.count != b.mediaAssets.count { return a.mediaAssets.count > b.mediaAssets.count }
            return (a.startDate ?? .distantPast) < (b.startDate ?? .distantPast)
        }

        return Array(sorted.prefix(limit))
    }
}
