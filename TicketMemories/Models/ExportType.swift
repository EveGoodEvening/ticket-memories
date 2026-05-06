import Foundation

enum ExportType: String, Codable {
    case eventCardImage
    case annualRecapImage
    case annualRecapPDF
    case printReadyPDF
}

enum ExportFormat: String, Codable {
    case png
    case jpeg
    case pdf
}
