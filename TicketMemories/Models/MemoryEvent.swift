import Foundation
import SwiftData

@Model
final class MemoryEvent {
    @Attribute(.unique) var id: UUID
    var title: String
    var category: EventCategory
    var startDate: Date?
    var endDate: Date?
    var timezoneIdentifier: String?
    var venueName: String?
    var address: String?
    var city: String?
    var country: String?
    var latitude: Double?
    var longitude: Double?
    var locationConfidence: LocationConfidence?
    var notes: String?
    var tags: [String]
    var coverMediaId: UUID?
    var source: EventSource
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \PassSnapshot.event)
    var passSnapshot: PassSnapshot?

    @Relationship(deleteRule: .cascade, inverse: \MediaAsset.event)
    var mediaAssets: [MediaAsset]

    @Relationship(deleteRule: .cascade, inverse: \SpotifyPlaylistLink.event)
    var spotifyLink: SpotifyPlaylistLink?

    @Relationship(deleteRule: .nullify, inverse: \ExportArtifact.event)
    var exportArtifacts: [ExportArtifact]

    var hasCoordinates: Bool {
        latitude != nil && longitude != nil
    }

    init(
        id: UUID = UUID(),
        title: String,
        category: EventCategory,
        startDate: Date? = nil,
        endDate: Date? = nil,
        timezoneIdentifier: String? = nil,
        venueName: String? = nil,
        address: String? = nil,
        city: String? = nil,
        country: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        locationConfidence: LocationConfidence? = nil,
        notes: String? = nil,
        tags: [String] = [],
        coverMediaId: UUID? = nil,
        source: EventSource = .manual,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.timezoneIdentifier = timezoneIdentifier
        self.venueName = venueName
        self.address = address
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.locationConfidence = locationConfidence
        self.notes = notes
        self.tags = tags
        self.coverMediaId = coverMediaId
        self.source = source
        self.isFavorite = isFavorite
        self.createdAt = Date()
        self.updatedAt = Date()
        self.mediaAssets = []
        self.exportArtifacts = []
    }
}
