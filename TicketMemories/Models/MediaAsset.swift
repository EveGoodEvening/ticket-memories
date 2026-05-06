import Foundation
import SwiftData

@Model
final class MediaAsset {
    @Attribute(.unique) var id: UUID
    var event: MemoryEvent?
    var type: MediaType
    var localFilePath: String
    var thumbnailPath: String?
    var originalFilename: String?
    var capturedAt: Date?
    var latitude: Double?
    var longitude: Double?
    var duration: Double?
    var width: Int?
    var height: Int?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        event: MemoryEvent? = nil,
        type: MediaType,
        localFilePath: String,
        thumbnailPath: String? = nil,
        originalFilename: String? = nil,
        capturedAt: Date? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        duration: Double? = nil,
        width: Int? = nil,
        height: Int? = nil
    ) {
        self.id = id
        self.event = event
        self.type = type
        self.localFilePath = localFilePath
        self.thumbnailPath = thumbnailPath
        self.originalFilename = originalFilename
        self.capturedAt = capturedAt
        self.latitude = latitude
        self.longitude = longitude
        self.duration = duration
        self.width = width
        self.height = height
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
