import Foundation

enum LocationConfidence: String, Codable {
    case exact
    case inferred
    case manual
    case unknown
}
