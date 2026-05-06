import SwiftUI
import SwiftData
import PhotosUI
import UniformTypeIdentifiers

struct MediaGallerySection: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var event: MemoryEvent
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isImporting = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(String(localized: "media.title", defaultValue: "Photos & Videos"))
                    .font(.headline)
                Spacer()
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 20,
                    matching: .any(of: [.images, .videos])
                ) {
                    Image(systemName: "plus.circle")
                }
                .onChange(of: selectedItems) { _, newItems in
                    importSelectedMedia(newItems)
                }
            }

            if event.mediaAssets.isEmpty {
                Text(String(localized: "media.empty", defaultValue: "No photos or videos yet. Tap + to add."))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                mediaGrid
            }

            if isImporting {
                ProgressView(String(localized: "media.importing", defaultValue: "Importing..."))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var mediaGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
        ], spacing: 4) {
            ForEach(event.mediaAssets) { asset in
                mediaCell(asset)
                    .contextMenu {
                        if event.coverMediaId != asset.id {
                            Button {
                                event.coverMediaId = asset.id
                                event.updatedAt = Date()
                            } label: {
                                Label(
                                    String(localized: "media.setCover", defaultValue: "Set as Cover"),
                                    systemImage: "photo"
                                )
                            }
                        }

                        Button(role: .destructive) {
                            removeAsset(asset)
                        } label: {
                            Label(
                                String(localized: "media.remove", defaultValue: "Remove"),
                                systemImage: "trash"
                            )
                        }
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func mediaCell(_ asset: MediaAsset) -> some View {
        ZStack(alignment: .topTrailing) {
            if let thumbnailPath = asset.thumbnailPath {
                AsyncImageFromFile(url: MediaStorageService.thumbnailURL(for: thumbnailPath))
            } else {
                AsyncImageFromFile(url: MediaStorageService.fullURL(for: asset.localFilePath))
            }

            if asset.type == .video {
                Image(systemName: "play.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
                    .padding(4)
            }

            if event.coverMediaId == asset.id {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
                    .padding(4)
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipped()
    }

    private func importSelectedMedia(_ items: [PhotosPickerItem]) {
        guard !items.isEmpty else { return }
        isImporting = true

        Task {
            for item in items {
                let isVideo = item.supportedContentTypes.contains(where: { $0.conforms(to: .movie) })
                guard let data = try? await item.loadTransferable(type: Data.self) else { continue }
                let filename = item.itemIdentifier ?? UUID().uuidString

                if isVideo {
                    if let result = try? MediaStorageService.importVideo(
                        data: data,
                        originalFilename: filename
                    ) {
                        let asset = MediaAsset(
                            event: event,
                            type: .video,
                            localFilePath: result.filePath,
                            thumbnailPath: result.thumbnailPath,
                            originalFilename: filename,
                            duration: result.duration
                        )
                        modelContext.insert(asset)
                        if event.coverMediaId == nil {
                            event.coverMediaId = asset.id
                        }
                    }
                } else {
                    if let result = try? MediaStorageService.importImage(
                        data: data,
                        originalFilename: filename
                    ) {
                        let asset = MediaAsset(
                            event: event,
                            type: .image,
                            localFilePath: result.filePath,
                            thumbnailPath: result.thumbnailPath,
                            originalFilename: filename,
                            width: result.width,
                            height: result.height
                        )
                        modelContext.insert(asset)
                        if event.coverMediaId == nil {
                            event.coverMediaId = asset.id
                        }
                    }
                }
            }
            event.updatedAt = Date()
            isImporting = false
            selectedItems = []
        }
    }

    private func removeAsset(_ asset: MediaAsset) {
        MediaStorageService.deleteMedia(filePath: asset.localFilePath, thumbnailPath: asset.thumbnailPath)
        if event.coverMediaId == asset.id {
            event.coverMediaId = nil
        }
        modelContext.delete(asset)
        event.updatedAt = Date()
    }
}

struct AsyncImageFromFile: View {
    let url: URL

    var body: some View {
        if let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(Color(.tertiarySystemBackground))
                .overlay {
                    Image(systemName: "photo")
                        .foregroundStyle(.quaternary)
                }
        }
    }
}
