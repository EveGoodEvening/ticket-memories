import SwiftUI
import SwiftData

struct SpotifyLinkSection: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var event: MemoryEvent
    @State private var urlInput = ""
    @State private var showingAddSheet = false
    @State private var validationError: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(String(localized: "spotify.title", defaultValue: "Spotify Playlist"))
                    .font(.headline)
                Spacer()
                if event.spotifyLink == nil {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }

            if let link = event.spotifyLink {
                spotifyCard(link)
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            addSpotifySheet
        }
    }

    private func spotifyCard(_ link: SpotifyPlaylistLink) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "music.note.list")
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 44, height: 44)
                .background(Color.green.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(link.name ?? String(localized: "spotify.playlist", defaultValue: "Playlist"))
                    .font(.subheadline.weight(.medium))
                if let owner = link.ownerName {
                    Text(owner)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Menu {
                if let url = SpotifyLinkService.openExternally(url: link.externalURL) {
                    Link(String(localized: "spotify.open", defaultValue: "Open in Spotify"), destination: url)
                }
                Button(role: .destructive) {
                    removeLink()
                } label: {
                    Label(String(localized: "spotify.remove", defaultValue: "Remove"), systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private var addSpotifySheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        String(localized: "spotify.urlPlaceholder", defaultValue: "Paste Spotify playlist URL..."),
                        text: $urlInput
                    )
                    .textContentType(.URL)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                }

                if let error = validationError {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle(String(localized: "spotify.add.title", defaultValue: "Add Playlist"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "spotify.add.cancel", defaultValue: "Cancel")) {
                        showingAddSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "spotify.add.save", defaultValue: "Add")) {
                        saveLink()
                    }
                    .disabled(urlInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func saveLink() {
        guard let result = SpotifyLinkService.validate(urlString: urlInput) else {
            validationError = String(localized: "spotify.error.invalid",
                                      defaultValue: "This doesn't look like a Spotify URL. Please paste a Spotify playlist link.")
            return
        }

        if !result.isValid {
            validationError = String(localized: "spotify.error.notPlaylist",
                                      defaultValue: "Could not find a playlist ID in this URL. Please paste a Spotify playlist link.")
            return
        }

        let link = SpotifyPlaylistLink(
            event: event,
            spotifyURI: result.normalizedURI,
            externalURL: result.externalURL
        )
        modelContext.insert(link)
        event.updatedAt = Date()
        showingAddSheet = false
    }

    private func removeLink() {
        if let link = event.spotifyLink {
            modelContext.delete(link)
            event.updatedAt = Date()
        }
    }
}
