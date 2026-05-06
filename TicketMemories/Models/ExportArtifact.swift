import Foundation
import SwiftData

@Model
final class ExportArtifact {
    @Attribute(.unique) var id: UUID
    var type: ExportType
    var event: MemoryEvent?
    var recap: AnnualRecap?
    var localFilePath: String
    var format: ExportFormat
    var createdAt: Date

    init(
        id: UUID = UUID(),
        type: ExportType,
        event: MemoryEvent? = nil,
        recap: AnnualRecap? = nil,
        localFilePath: String,
        format: ExportFormat
    ) {
        self.id = id
        self.type = type
        self.event = event
        self.recap = recap
        self.localFilePath = localFilePath
        self.format = format
        self.createdAt = Date()
    }
}
