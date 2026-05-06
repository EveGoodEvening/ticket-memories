import Foundation
import SwiftData

struct SampleData {
    static let events: [MemoryEvent] = [
        MemoryEvent(
            title: "Taylor Swift | The Eras Tour",
            category: .concert,
            startDate: date(2025, 6, 15),
            venueName: "Mercedes-Benz Arena",
            city: "Shanghai",
            country: "China",
            latitude: 31.1812,
            longitude: 121.4737,
            locationConfidence: .exact,
            notes: "An unforgettable night. The stage production was incredible.",
            source: .manual,
            isFavorite: true
        ),
        MemoryEvent(
            title: "Strawberry Music Festival",
            category: .musicFestival,
            startDate: date(2025, 5, 1),
            endDate: date(2025, 5, 3),
            venueName: "Beijing Yanqing",
            city: "Beijing",
            country: "China",
            latitude: 40.4565,
            longitude: 115.9850,
            locationConfidence: .exact,
            source: .manual
        ),
        MemoryEvent(
            title: "teamLab Borderless",
            category: .exhibition,
            startDate: date(2025, 3, 22),
            venueName: "teamLab Borderless Shanghai",
            city: "Shanghai",
            country: "China",
            latitude: 31.2300,
            longitude: 121.4900,
            locationConfidence: .exact,
            notes: "The digital art was mesmerizing. Spent 3 hours inside.",
            source: .manual
        ),
        MemoryEvent(
            title: "Trip to Kyoto",
            category: .travel,
            startDate: date(2025, 4, 5),
            endDate: date(2025, 4, 10),
            city: "Kyoto",
            country: "Japan",
            latitude: 35.0116,
            longitude: 135.7681,
            locationConfidence: .exact,
            source: .manual,
            isFavorite: true
        ),
        MemoryEvent(
            title: "CBA Finals Game 3",
            category: .sports,
            startDate: date(2025, 4, 20),
            venueName: "Wukesong Arena",
            city: "Beijing",
            country: "China",
            latitude: 39.9066,
            longitude: 116.2834,
            locationConfidence: .exact,
            source: .manual
        ),
        MemoryEvent(
            title: "Hamilton",
            category: .theater,
            startDate: date(2024, 12, 10),
            venueName: "Shanghai Culture Square",
            city: "Shanghai",
            country: "China",
            latitude: 31.2100,
            longitude: 121.4600,
            locationConfidence: .exact,
            source: .manual
        ),
        MemoryEvent(
            title: "Unknown Date Event",
            category: .other,
            source: .manual
        ),
    ]

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    @MainActor
    static func populate(context: ModelContext) {
        for event in events {
            context.insert(event)
        }
    }
}
