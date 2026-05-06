import SwiftUI

enum EventCategory: String, Codable, CaseIterable, Identifiable {
    case concert
    case musicFestival
    case exhibition
    case travel
    case sports
    case theater
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .concert: String(localized: "category.concert", defaultValue: "Concert")
        case .musicFestival: String(localized: "category.musicFestival", defaultValue: "Music Festival")
        case .exhibition: String(localized: "category.exhibition", defaultValue: "Exhibition")
        case .travel: String(localized: "category.travel", defaultValue: "Travel")
        case .sports: String(localized: "category.sports", defaultValue: "Sports")
        case .theater: String(localized: "category.theater", defaultValue: "Theater")
        case .other: String(localized: "category.other", defaultValue: "Other")
        }
    }

    var iconName: String {
        switch self {
        case .concert: "music.mic"
        case .musicFestival: "music.note.list"
        case .exhibition: "paintpalette"
        case .travel: "airplane"
        case .sports: "sportscourt"
        case .theater: "theatermasks"
        case .other: "ticket"
        }
    }

    var color: Color {
        switch self {
        case .concert: Color(hex: 0xFF6B6B)
        case .musicFestival: Color(hex: 0xFF9F43)
        case .exhibition: Color(hex: 0x54A0FF)
        case .travel: Color(hex: 0x5F27CD)
        case .sports: Color(hex: 0x10AC84)
        case .theater: Color(hex: 0xEE5A24)
        case .other: Color(hex: 0x636E72)
        }
    }
}

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
