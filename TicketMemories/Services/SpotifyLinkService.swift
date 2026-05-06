import Foundation

struct SpotifyLinkService {
    struct ValidationResult {
        let isValid: Bool
        let playlistId: String?
        let normalizedURI: String?
        let externalURL: String
    }

    static func validate(urlString: String) -> ValidationResult? {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let playlistId = extractPlaylistId(from: trimmed) {
            return ValidationResult(
                isValid: true,
                playlistId: playlistId,
                normalizedURI: "spotify:playlist:\(playlistId)",
                externalURL: "https://open.spotify.com/playlist/\(playlistId)"
            )
        }

        if trimmed.contains("spotify.com") || trimmed.starts(with: "spotify:") {
            return ValidationResult(
                isValid: false,
                playlistId: nil,
                normalizedURI: nil,
                externalURL: trimmed
            )
        }

        return nil
    }

    private static func extractPlaylistId(from input: String) -> String? {
        if input.starts(with: "spotify:playlist:") {
            let id = String(input.dropFirst("spotify:playlist:".count))
            return id.isEmpty ? nil : id
        }

        guard let url = URL(string: input),
              let host = url.host,
              host.contains("spotify.com") else {
            return nil
        }

        let pathComponents = url.pathComponents
        guard let playlistIndex = pathComponents.firstIndex(of: "playlist"),
              playlistIndex + 1 < pathComponents.count else {
            return nil
        }

        let id = pathComponents[playlistIndex + 1]
        return id.isEmpty ? nil : id
    }

    static func openExternally(url: String) -> URL? {
        URL(string: url)
    }
}
