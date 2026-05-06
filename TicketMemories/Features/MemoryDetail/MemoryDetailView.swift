import SwiftUI
import SwiftData
import MapKit

struct MemoryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var event: MemoryEvent
    @State private var showingEditSheet = false
    @State private var showingDeleteConfirmation = false
    @ScaledMetric(relativeTo: .largeTitle) private var heroIconSize: CGFloat = 64

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroCover
                detailContent
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label(String(localized: "detail.edit", defaultValue: "Edit"), systemImage: "pencil")
                    }

                    Button {
                        event.isFavorite.toggle()
                        event.updatedAt = Date()
                    } label: {
                        Label(
                            event.isFavorite
                                ? String(localized: "detail.unfavorite", defaultValue: "Remove from Favorites")
                                : String(localized: "detail.favorite", defaultValue: "Add to Favorites"),
                            systemImage: event.isFavorite ? "heart.slash" : "heart"
                        )
                    }

                    EventExportButton(event: event)

                    Divider()

                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        Label(String(localized: "detail.delete", defaultValue: "Delete"), systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditMemoryView(event: event)
        }
        .confirmationDialog(
            String(localized: "detail.deleteConfirm.title", defaultValue: "Delete Memory?"),
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: "detail.deleteConfirm.action", defaultValue: "Delete"), role: .destructive) {
                modelContext.delete(event)
                dismiss()
            }
        } message: {
            Text(String(localized: "detail.deleteConfirm.message",
                         defaultValue: "This will permanently delete this memory and all attached media."))
        }
    }

    private var heroCover: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(event.category.color.gradient)
                .frame(height: 240)
                .overlay {
                    Image(systemName: event.category.iconName)
                        .font(.system(size: heroIconSize))
                        .foregroundStyle(.white.opacity(0.3))
                }

            VStack(alignment: .leading, spacing: 4) {
                if event.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.white)
                }
                Text(event.title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(20)
        }
    }

    private var detailContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            infoSection

            MediaGallerySection(event: event)

            if let notes = event.notes, !notes.isEmpty {
                notesSection(notes)
            }

            SpotifyLinkSection(event: event)

            if event.hasCoordinates {
                mapPreview
            }
        }
        .padding(20)
    }

    private var mapPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "detail.mapPreview", defaultValue: "Location"))
                .font(.headline)

            if let lat = event.latitude, let lon = event.longitude {
                Map {
                    Marker(event.title, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                        .tint(event.category.color)
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .allowsHitTesting(false)
            }
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(icon: event.category.iconName, text: event.category.displayName)

            if let date = event.startDate {
                detailRow(icon: "calendar", text: date.formatted(.dateTime.year().month().day().weekday()))
            }

            if let venue = event.venueName {
                detailRow(icon: "building.2", text: venue)
            }

            if let city = event.city {
                let location = [city, event.country].compactMap { $0 }.joined(separator: ", ")
                detailRow(icon: "mappin.and.ellipse", text: location)
            }
        }
    }

    private func notesSection(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "detail.notes", defaultValue: "Notes"))
                .font(.headline)
            Text(notes)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private func detailRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.secondary)
            Text(text)
                .font(.body)
        }
    }
}
