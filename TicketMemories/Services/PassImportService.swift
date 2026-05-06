import Foundation
import PassKit
import CryptoKit

struct PassImportResult {
    var title: String?
    var organizationName: String?
    var localizedDescription: String?
    var relevantDate: Date?
    var serialNumberHash: String?
    var passTypeIdentifierHash: String?
    var passURL: String?
    var foregroundColor: String?
    var backgroundColor: String?
    var labelColor: String?
    var thumbnailData: Data?
}

enum PassImportError: LocalizedError {
    case invalidFile
    case unreadablePass
    case noUsefulMetadata

    var errorDescription: String? {
        switch self {
        case .invalidFile:
            String(localized: "import.error.invalidFile", defaultValue: "This file is not a valid .pkpass file.")
        case .unreadablePass:
            String(localized: "import.error.unreadable", defaultValue: "Could not read this pass. The file may be corrupted.")
        case .noUsefulMetadata:
            String(localized: "import.error.noMetadata", defaultValue: "No useful information could be extracted from this pass.")
        }
    }
}

struct PassImportService {
    static func importPass(from fileURL: URL) throws -> PassImportResult {
        guard fileURL.pathExtension.lowercased() == "pkpass" else {
            throw PassImportError.invalidFile
        }

        let data: Data
        do {
            let accessing = fileURL.startAccessingSecurityScopedResource()
            defer { if accessing { fileURL.stopAccessingSecurityScopedResource() } }
            data = try Data(contentsOf: fileURL)
        } catch {
            throw PassImportError.invalidFile
        }

        guard let pass = try? PKPass(data: data) else {
            throw PassImportError.unreadablePass
        }

        var result = PassImportResult()

        result.title = pass.localizedName.nilIfEmpty
        result.organizationName = pass.organizationName.nilIfEmpty
        result.localizedDescription = pass.localizedDescription.nilIfEmpty
        result.relevantDate = pass.relevantDate

        if let serialNumber = pass.serialNumber {
            result.serialNumberHash = sha256Hash(serialNumber)
        }

        result.passTypeIdentifierHash = sha256Hash(pass.passTypeIdentifier)

        if let passURL = pass.passURL {
            result.passURL = passURL.absoluteString
        }

        result.foregroundColor = pass.foregroundColor?.hexString
        result.backgroundColor = pass.backgroundColor?.hexString
        result.labelColor = pass.labelColor?.hexString

        result.thumbnailData = pass.icon

        if result.title == nil && result.organizationName == nil && result.relevantDate == nil {
            throw PassImportError.noUsefulMetadata
        }

        return result
    }

    static func computeDuplicateHash(result: PassImportResult) -> String? {
        guard let passHash = result.passTypeIdentifierHash,
              let serialHash = result.serialNumberHash else {
            return nil
        }
        return sha256Hash("\(passHash):\(serialHash)")
    }

    private static func sha256Hash(_ input: String) -> String {
        let data = Data(input.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

#if canImport(UIKit)
import UIKit

extension UIColor {
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
#endif
