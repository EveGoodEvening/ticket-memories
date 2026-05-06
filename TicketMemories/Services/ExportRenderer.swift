import SwiftUI
import UIKit

struct ExportRenderer {
    static let eventCardSize = CGSize(width: 1080, height: 1350)
    static let recapImageWidth: CGFloat = 1080

    @MainActor
    static func renderEventCard(event: MemoryEvent) -> UIImage? {
        let view = ExportEventCardView(event: event)
        let renderer = ImageRenderer(content: view.frame(width: eventCardSize.width, height: eventCardSize.height))
        renderer.scale = 2.0
        return renderer.uiImage
    }

    @MainActor
    static func renderRecapImage(stats: RecapStats, year: Int, highlights: [MemoryEvent]) -> UIImage? {
        let view = ExportRecapView(year: year, stats: stats, highlights: highlights)
        let renderer = ImageRenderer(content: view.frame(width: recapImageWidth))
        renderer.scale = 2.0
        return renderer.uiImage
    }

    static func saveImage(_ image: UIImage, filename: String) throws -> URL {
        try MediaStorageService.ensureDirectoriesExist()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let exportsDir = documentsURL.appending(path: "Exports")
        try FileManager.default.createDirectory(at: exportsDir, withIntermediateDirectories: true)

        let fileURL = exportsDir.appending(path: filename)
        guard let data = image.pngData() else {
            throw ExportError.renderingFailed
        }
        try data.write(to: fileURL)
        return fileURL
    }
}

enum ExportError: LocalizedError {
    case renderingFailed
    case fileWriteFailed
    case noExportableContent

    var errorDescription: String? {
        switch self {
        case .renderingFailed:
            String(localized: "export.error.rendering", defaultValue: "Failed to render the export image.")
        case .fileWriteFailed:
            String(localized: "export.error.fileWrite", defaultValue: "Failed to save the exported file.")
        case .noExportableContent:
            String(localized: "export.error.noContent", defaultValue: "No content available to export.")
        }
    }
}

struct ExportEventCardView: View {
    let event: MemoryEvent

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(event.category.color.gradient)
                    .frame(height: 600)
                    .overlay {
                        Image(systemName: event.category.iconName)
                            .font(.system(size: 120))
                            .foregroundStyle(.white.opacity(0.2))
                    }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: event.category.iconName)
                        Text(event.category.displayName)
                    }
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                }
                .padding(40)
            }

            VStack(alignment: .leading, spacing: 20) {
                Text(event.title)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .lineLimit(3)

                if let date = event.startDate {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                        Text(date.formatted(.dateTime.year().month().day().weekday()))
                    }
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
                }

                if let venue = event.venueName {
                    HStack(spacing: 8) {
                        Image(systemName: "mappin")
                        Text(venue)
                    }
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
                }

                if let city = event.city {
                    HStack(spacing: 8) {
                        Image(systemName: "building.2")
                        Text([city, event.country].compactMap { $0 }.joined(separator: ", "))
                    }
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
                }

                Spacer()

                HStack {
                    Spacer()
                    Text("Ticket Memories")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.quaternary)
                }
            }
            .padding(40)
        }
        .background(Color(.systemBackground))
    }
}

struct ExportRecapView: View {
    let year: Int
    let stats: RecapStats
    let highlights: [MemoryEvent]

    var body: some View {
        VStack(spacing: 32) {
            Text("\(year)")
                .font(.system(size: 72, weight: .bold, design: .rounded))

            Text(String(localized: "export.recap.title", defaultValue: "Year in Review"))
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                exportStatTile(value: "\(stats.totalEvents)", label: "Events")
                exportStatTile(value: "\(stats.totalCities)", label: "Cities")
                exportStatTile(value: "\(stats.totalCountries)", label: "Countries")
                exportStatTile(value: "\(stats.highlightMediaCount)", label: "Photos")
            }

            if let city = stats.favoriteCity {
                VStack(spacing: 4) {
                    Text("Favorite City")
                        .font(.system(size: 18))
                        .foregroundStyle(.secondary)
                    Text(city)
                        .font(.system(size: 28, weight: .semibold))
                }
            }

            if !highlights.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Highlights")
                        .font(.system(size: 24, weight: .semibold))

                    ForEach(highlights) { event in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(event.category.color)
                                .frame(width: 8, height: 36)
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .font(.system(size: 18, weight: .medium))
                                if let date = event.startDate {
                                    Text(date.formatted(.dateTime.month(.abbreviated).day()))
                                        .font(.system(size: 14))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                Spacer()
                Text("Ticket Memories")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.quaternary)
            }
        }
        .padding(48)
        .background(Color(.systemBackground))
    }

    private func exportStatTile(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 40, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}
