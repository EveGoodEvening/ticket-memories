import Foundation

enum EventSource: String, Codable {
    case pkpassFile
    case manual
    case qrScan
    case walletUserSelected
    case screenshot
}
