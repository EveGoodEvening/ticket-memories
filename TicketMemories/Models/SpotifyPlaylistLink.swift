import Foundation
import SwiftData

@Model
final class SpotifyPlaylistLink {
    @Attribute(.unique) var id: UUID
    var event: MemoryEvent?
    var spotifyURI: String?
    var externalURL: String
    var name: String?
    var ownerName: String?
    var imageURL: String?
    var trackCount: Int?
    var linkedAt: Date

    init(
        id: UUID = UUID(),
        event: MemoryEvent? = nil,
        spotifyURI: String? = nil,
        externalURL: String,
        name: String? = nil,
        ownerName: String? = nil,
        imageURL: String? = nil,
        trackCount: Int? = nil
    ) {
        self.id = id
        self.event = event
        self.spotifyURI = spotifyURI
        self.externalURL = externalURL
        self.name = name
        self.ownerName = ownerName
        self.imageURL = imageURL
        self.trackCount = trackCount
        self.linkedAt = Date()
    }
}
