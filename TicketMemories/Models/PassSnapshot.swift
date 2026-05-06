import Foundation
import SwiftData

@Model
final class PassSnapshot {
    @Attribute(.unique) var id: UUID
    var event: MemoryEvent?
    var organizationName: String?
    var localizedName: String?
    var localizedDescription: String?
    var serialNumberHash: String?
    var passTypeIdentifierHash: String?
    var relevantDate: Date?
    var passURL: String?
    var thumbnailImagePath: String?
    var foregroundColor: String?
    var backgroundColor: String?
    var labelColor: String?
    var barcodeStoredPolicy: BarcodeStoredPolicy
    var createdAt: Date

    init(
        id: UUID = UUID(),
        event: MemoryEvent? = nil,
        organizationName: String? = nil,
        localizedName: String? = nil,
        localizedDescription: String? = nil,
        serialNumberHash: String? = nil,
        passTypeIdentifierHash: String? = nil,
        relevantDate: Date? = nil,
        passURL: String? = nil,
        thumbnailImagePath: String? = nil,
        foregroundColor: String? = nil,
        backgroundColor: String? = nil,
        labelColor: String? = nil,
        barcodeStoredPolicy: BarcodeStoredPolicy = .notStored
    ) {
        self.id = id
        self.event = event
        self.organizationName = organizationName
        self.localizedName = localizedName
        self.localizedDescription = localizedDescription
        self.serialNumberHash = serialNumberHash
        self.passTypeIdentifierHash = passTypeIdentifierHash
        self.relevantDate = relevantDate
        self.passURL = passURL
        self.thumbnailImagePath = thumbnailImagePath
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.labelColor = labelColor
        self.barcodeStoredPolicy = barcodeStoredPolicy
        self.createdAt = Date()
    }
}
