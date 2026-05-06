import Foundation

enum BarcodeStoredPolicy: String, Codable {
    case notStored
    case hashedOnly
    case storedWithConsent
}
