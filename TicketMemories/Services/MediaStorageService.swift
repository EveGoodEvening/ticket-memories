import Foundation
import UIKit
import SwiftData

struct MediaStorageService {
    static let mediaDirectoryName = "EventMedia"
    static let thumbnailDirectoryName = "Thumbnails"
    static let thumbnailMaxSize: CGFloat = 300

    static var mediaDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appending(path: mediaDirectoryName)
    }

    static var thumbnailDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appending(path: thumbnailDirectoryName)
    }

    static func ensureDirectoriesExist() throws {
        let fm = FileManager.default
        try fm.createDirectory(at: mediaDirectory, withIntermediateDirectories: true)
        try fm.createDirectory(at: thumbnailDirectory, withIntermediateDirectories: true)
    }

    static func importImage(data: Data, originalFilename: String?) throws -> (filePath: String, thumbnailPath: String?, width: Int?, height: Int?) {
        try ensureDirectoriesExist()

        let fileId = UUID().uuidString
        let ext = (originalFilename as NSString?)?.pathExtension ?? "jpg"
        let filename = "\(fileId).\(ext)"

        let destinationURL = mediaDirectory.appending(path: filename)
        try data.write(to: destinationURL)

        var width: Int?
        var height: Int?
        var thumbnailPath: String?

        if let image = UIImage(data: data) {
            width = Int(image.size.width * image.scale)
            height = Int(image.size.height * image.scale)
            thumbnailPath = try generateThumbnail(from: image, fileId: fileId)
        }

        return (filename, thumbnailPath, width, height)
    }

    private static func generateThumbnail(from image: UIImage, fileId: String) throws -> String? {
        let maxDimension = thumbnailMaxSize
        let size = image.size
        let scale: CGFloat
        if size.width > size.height {
            scale = maxDimension / size.width
        } else {
            scale = maxDimension / size.height
        }

        guard scale < 1.0 else {
            return nil
        }

        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let thumbnailImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        let thumbnailFilename = "\(fileId)_thumb.jpg"
        let thumbnailURL = thumbnailDirectory.appending(path: thumbnailFilename)
        if let jpegData = thumbnailImage.jpegData(compressionQuality: 0.7) {
            try jpegData.write(to: thumbnailURL)
            return thumbnailFilename
        }

        return nil
    }

    static func deleteMedia(filePath: String, thumbnailPath: String?) {
        let fm = FileManager.default
        let mediaURL = mediaDirectory.appending(path: filePath)
        try? fm.removeItem(at: mediaURL)

        if let thumbnailPath {
            let thumbURL = thumbnailDirectory.appending(path: thumbnailPath)
            try? fm.removeItem(at: thumbURL)
        }
    }

    static func fullURL(for relativePath: String) -> URL {
        mediaDirectory.appending(path: relativePath)
    }

    static func thumbnailURL(for relativePath: String) -> URL {
        thumbnailDirectory.appending(path: relativePath)
    }
}
