import SwiftUI
import UIKit
import PDFKit
import MapKit
import CoreImage.CIFilterBuiltins

struct PDFExportOptions {
    enum PageSize {
        case a4
        case letter

        var dimensions: CGSize {
            switch self {
            case .a4: CGSize(width: 595.28, height: 841.89)
            case .letter: CGSize(width: 612, height: 792)
            }
        }
    }

    var pageSize: PageSize = .a4
    var includePhotos: Bool = true
    var includeNotes: Bool = true
    var includeMap: Bool = true
    var includeSpotifyLink: Bool = true
}

struct PDFExportService {
    static let margin: CGFloat = 50

    @MainActor
    static func generateRecapPDF(
        year: Int,
        stats: RecapStats,
        events: [MemoryEvent],
        options: PDFExportOptions = PDFExportOptions()
    ) async throws -> URL {
        let pageSize = options.pageSize.dimensions
        let contentWidth = pageSize.width - (margin * 2)
        let mapSize = CGSize(width: pageSize.width - margin * 2, height: pageSize.height - margin * 2 - 50)
        let mapSnapshot = options.includeMap ? await captureMapSnapshot(events: events, size: mapSize) : nil

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))

        let data = pdfRenderer.pdfData { context in
            renderCoverPage(context: context, pageSize: pageSize, year: year, stats: stats)
            renderStatsPage(context: context, pageSize: pageSize, stats: stats, contentWidth: contentWidth)

            for event in events.prefix(20) {
                renderEventPage(context: context, pageSize: pageSize, event: event, contentWidth: contentWidth, options: options)
            }

            renderMapPage(context: context, pageSize: pageSize, events: events, options: options, mapSnapshot: mapSnapshot)
        }

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let exportsDir = documentsURL.appending(path: "Exports")
        try FileManager.default.createDirectory(at: exportsDir, withIntermediateDirectories: true)

        let filename = "TicketMemories_\(year)_Recap.pdf"
        let fileURL = exportsDir.appending(path: filename)
        try data.write(to: fileURL)
        return fileURL
    }

    @MainActor
    static func generatePrintReadyPDF(
        year: Int,
        stats: RecapStats,
        events: [MemoryEvent],
        options: PDFExportOptions = PDFExportOptions()
    ) async throws -> URL {
        let pageSize = options.pageSize.dimensions
        let contentWidth = pageSize.width - (margin * 2)
        let mapSize = CGSize(width: pageSize.width - margin * 2, height: pageSize.height - margin * 2 - 50)
        let mapSnapshot = options.includeMap ? await captureMapSnapshot(events: events, size: mapSize) : nil

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))

        let data = pdfRenderer.pdfData { context in
            renderCoverPage(context: context, pageSize: pageSize, year: year, stats: stats)
            renderStatsPage(context: context, pageSize: pageSize, stats: stats, contentWidth: contentWidth)

            for event in events {
                renderEventPage(context: context, pageSize: pageSize, event: event, contentWidth: contentWidth, options: options)
            }

            renderMapPage(context: context, pageSize: pageSize, events: events, options: options, mapSnapshot: mapSnapshot)
            renderClosingPage(context: context, pageSize: pageSize)
        }

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let exportsDir = documentsURL.appending(path: "Exports")
        try FileManager.default.createDirectory(at: exportsDir, withIntermediateDirectories: true)

        let filename = "TicketMemories_\(year)_PrintReady.pdf"
        let fileURL = exportsDir.appending(path: filename)
        try data.write(to: fileURL)
        return fileURL
    }

    private static func renderCoverPage(context: UIGraphicsPDFRendererContext, pageSize: CGSize, year: Int, stats: RecapStats) {
        context.beginPage()

        let titleFont = UIFont.systemFont(ofSize: 48, weight: .bold)
        let subtitleFont = UIFont.systemFont(ofSize: 20, weight: .medium)
        let brandFont = UIFont.systemFont(ofSize: 12, weight: .regular)

        let yearText = "\(year)" as NSString
        let yearSize = yearText.size(withAttributes: [.font: titleFont])
        yearText.draw(
            at: CGPoint(x: (pageSize.width - yearSize.width) / 2, y: pageSize.height * 0.35),
            withAttributes: [.font: titleFont, .foregroundColor: UIColor.label]
        )

        let subtitle = "Year in Review" as NSString
        let subtitleSize = subtitle.size(withAttributes: [.font: subtitleFont])
        subtitle.draw(
            at: CGPoint(x: (pageSize.width - subtitleSize.width) / 2, y: pageSize.height * 0.35 + yearSize.height + 12),
            withAttributes: [.font: subtitleFont, .foregroundColor: UIColor.secondaryLabel]
        )

        let summary = "\(stats.totalEvents) events · \(stats.totalCities) cities · \(stats.totalCountries) countries" as NSString
        let summarySize = summary.size(withAttributes: [.font: subtitleFont])
        summary.draw(
            at: CGPoint(x: (pageSize.width - summarySize.width) / 2, y: pageSize.height * 0.45),
            withAttributes: [.font: subtitleFont, .foregroundColor: UIColor.tertiaryLabel]
        )

        let brand = "Ticket Memories" as NSString
        let brandSize = brand.size(withAttributes: [.font: brandFont])
        brand.draw(
            at: CGPoint(x: (pageSize.width - brandSize.width) / 2, y: pageSize.height - margin - brandSize.height),
            withAttributes: [.font: brandFont, .foregroundColor: UIColor.quaternaryLabel]
        )
    }

    private static func renderStatsPage(context: UIGraphicsPDFRendererContext, pageSize: CGSize, stats: RecapStats, contentWidth: CGFloat) {
        context.beginPage()

        let headerFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let labelFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        let valueFont = UIFont.systemFont(ofSize: 28, weight: .bold)

        var yOffset: CGFloat = margin

        let title = "Statistics" as NSString
        title.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: headerFont, .foregroundColor: UIColor.label])
        yOffset += 50

        let statItems: [(String, String)] = [
            ("Total Events", "\(stats.totalEvents)"),
            ("Cities Visited", "\(stats.totalCities)"),
            ("Countries", "\(stats.totalCountries)"),
            ("Photos", "\(stats.highlightMediaCount)"),
        ]

        for (label, value) in statItems {
            (value as NSString).draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: valueFont, .foregroundColor: UIColor.label])
            yOffset += 34
            (label as NSString).draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: labelFont, .foregroundColor: UIColor.secondaryLabel])
            yOffset += 40
        }

        if let city = stats.favoriteCity {
            yOffset += 20
            ("Favorite City" as NSString).draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: labelFont, .foregroundColor: UIColor.secondaryLabel])
            yOffset += 20
            (city as NSString).draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: valueFont, .foregroundColor: UIColor.label])
        }
    }

    private static func renderEventPage(context: UIGraphicsPDFRendererContext, pageSize: CGSize, event: MemoryEvent, contentWidth: CGFloat, options: PDFExportOptions) {
        context.beginPage()

        let titleFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        let bodyFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        let labelFont = UIFont.systemFont(ofSize: 12, weight: .medium)

        var yOffset: CGFloat = margin

        let title = event.title as NSString
        let titleRect = CGRect(x: margin, y: yOffset, width: contentWidth, height: 100)
        title.draw(in: titleRect, withAttributes: [.font: titleFont, .foregroundColor: UIColor.label])
        yOffset += 36

        let category = event.category.displayName as NSString
        category.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: labelFont, .foregroundColor: UIColor.secondaryLabel])
        yOffset += 30

        if let date = event.startDate {
            let dateStr = date.formatted(.dateTime.year().month().day().weekday()) as NSString
            dateStr.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: UIColor.label])
            yOffset += 24
        }

        if let venue = event.venueName {
            (venue as NSString).draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: UIColor.label])
            yOffset += 24
        }

        if let city = event.city {
            let location = [city, event.country].compactMap { $0 }.joined(separator: ", ")
            (location as NSString).draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: UIColor.secondaryLabel])
            yOffset += 24
        }

        if options.includeNotes, let notes = event.notes, !notes.isEmpty {
            yOffset += 16
            let notesRect = CGRect(x: margin, y: yOffset, width: contentWidth, height: 200)
            (notes as NSString).draw(in: notesRect, withAttributes: [
                .font: bodyFont,
                .foregroundColor: UIColor.secondaryLabel,
            ])
            yOffset += min(200, (notes as NSString).boundingRect(
                with: CGSize(width: contentWidth, height: 200),
                options: .usesLineFragmentOrigin,
                attributes: [.font: bodyFont],
                context: nil
            ).height) + 16
        }

        if options.includePhotos {
            let imageAssets = event.mediaAssets.filter { $0.type == .image }
            if !imageAssets.isEmpty {
                yOffset += 16
                let photoSize: CGFloat = (contentWidth - 8) / 3
                var xOffset: CGFloat = margin
                for asset in imageAssets.prefix(6) {
                    let imageURL = asset.thumbnailPath.map { MediaStorageService.thumbnailURL(for: $0) }
                        ?? MediaStorageService.fullURL(for: asset.localFilePath)
                    if let data = try? Data(contentsOf: imageURL),
                       let image = UIImage(data: data) {
                        let rect = CGRect(x: xOffset, y: yOffset, width: photoSize, height: photoSize)
                        image.draw(in: rect)
                        xOffset += photoSize + 4
                        if xOffset + photoSize > pageSize.width - margin {
                            xOffset = margin
                            yOffset += photoSize + 4
                        }
                    }
                }
            }
        }

        if options.includeSpotifyLink, let spotifyLink = event.spotifyLink {
            yOffset += 20
            let spotifyLabel = "Spotify Playlist" as NSString
            spotifyLabel.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: labelFont, .foregroundColor: UIColor.secondaryLabel])
            yOffset += 18
            let urlText = spotifyLink.externalURL as NSString
            urlText.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: UIColor.systemBlue])
            yOffset += 20

            if let qrImage = generateQRCode(from: spotifyLink.externalURL) {
                let qrSize: CGFloat = 80
                let qrRect = CGRect(x: margin, y: yOffset, width: qrSize, height: qrSize)
                qrImage.draw(in: qrRect)
            }
        }
    }

    static func renderMapPage(context: UIGraphicsPDFRendererContext, pageSize: CGSize, events: [MemoryEvent], options: PDFExportOptions, mapSnapshot: UIImage?) {
        guard options.includeMap else { return }
        let eventsWithCoordinates = events.filter { $0.hasCoordinates }
        guard !eventsWithCoordinates.isEmpty else { return }
        guard let mapImage = mapSnapshot else { return }

        context.beginPage()

        let headerFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        ("Map" as NSString).draw(at: CGPoint(x: margin, y: margin), withAttributes: [.font: headerFont, .foregroundColor: UIColor.label])

        let mapRect = CGRect(x: margin, y: margin + 50, width: pageSize.width - margin * 2, height: pageSize.height - margin * 2 - 50)
        mapImage.draw(in: mapRect)
    }

    static func captureMapSnapshot(events: [MemoryEvent], size: CGSize) async -> UIImage? {
        let coordinates = events.compactMap { event -> CLLocationCoordinate2D? in
            guard let lat = event.latitude, let lon = event.longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        guard !coordinates.isEmpty else { return nil }

        let region = regionForCoordinates(coordinates)
        let snapshotOptions = MKMapSnapshotter.Options()
        snapshotOptions.region = region
        snapshotOptions.size = size
        snapshotOptions.scale = 2.0

        let snapshotter = MKMapSnapshotter(options: snapshotOptions)
        guard let snapshot = try? await snapshotter.start() else { return nil }

        let renderer = UIGraphicsImageRenderer(size: snapshot.image.size)
        return renderer.image { ctx in
            snapshot.image.draw(at: .zero)
            let pinSize = CGSize(width: 12, height: 12)
            for coordinate in coordinates {
                let point = snapshot.point(for: coordinate)
                let pinRect = CGRect(
                    x: point.x - pinSize.width / 2,
                    y: point.y - pinSize.height / 2,
                    width: pinSize.width,
                    height: pinSize.height
                )
                ctx.cgContext.setFillColor(UIColor.systemRed.cgColor)
                ctx.cgContext.fillEllipse(in: pinRect)
            }
        }
    }

    private static func regionForCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            return MKCoordinateRegion()
        }
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude

        for coord in coordinates {
            minLat = min(minLat, coord.latitude)
            maxLat = max(maxLat, coord.latitude)
            minLon = min(minLon, coord.longitude)
            maxLon = max(maxLon, coord.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.3, 0.01),
            longitudeDelta: max((maxLon - minLon) * 1.3, 0.01)
        )
        return MKCoordinateRegion(center: center, span: span)
    }

    private static func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return nil }
        let scale = 80.0 / outputImage.extent.width
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    private static func renderClosingPage(context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        context.beginPage()

        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let text = "Made with Ticket Memories" as NSString
        let size = text.size(withAttributes: [.font: font])
        text.draw(
            at: CGPoint(x: (pageSize.width - size.width) / 2, y: pageSize.height / 2),
            withAttributes: [.font: font, .foregroundColor: UIColor.tertiaryLabel]
        )
    }
}
