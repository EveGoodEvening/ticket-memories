import Foundation
import SwiftData

@Model
final class AnnualRecap {
    @Attribute(.unique) var id: UUID
    var year: Int
    var title: String?
    var themeId: String
    var generatedAt: Date
    var coverImagePath: String?
    var shareImagePath: String?
    var pdfPath: String?
    var statsJSON: String?

    @Relationship(deleteRule: .nullify, inverse: \ExportArtifact.recap)
    var exportArtifacts: [ExportArtifact]

    init(
        id: UUID = UUID(),
        year: Int,
        title: String? = nil,
        themeId: String = "classicTimeline",
        coverImagePath: String? = nil,
        shareImagePath: String? = nil,
        pdfPath: String? = nil,
        statsJSON: String? = nil
    ) {
        self.id = id
        self.year = year
        self.title = title
        self.themeId = themeId
        self.generatedAt = Date()
        self.coverImagePath = coverImagePath
        self.shareImagePath = shareImagePath
        self.pdfPath = pdfPath
        self.statsJSON = statsJSON
        self.exportArtifacts = []
    }
}
