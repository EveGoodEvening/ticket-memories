import SwiftUI

struct TimelineEventCard: View {
    let event: MemoryEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            coverSection
            detailSection
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }

    private var coverSection: some View {
        ZStack {
            Rectangle()
                .fill(event.category.color.gradient)
                .frame(height: 180)
                .overlay {
                    Image(systemName: event.category.iconName)
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.4))
                }

            VStack {
                HStack {
                    Spacer()
                    categoryBadge
                        .padding(12)
                }
                Spacer()
            }
        }
        .frame(height: 180)
        .clipped()
    }

    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.system(.headline, design: .rounded))
                .lineLimit(2)

            HStack(spacing: 16) {
                if let date = event.startDate {
                    Label(date.formatted(.dateTime.month(.abbreviated).day().year()),
                          systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let venue = event.venueName ?? event.city {
                    Label(venue, systemImage: "mappin")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            if event.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .padding(16)
    }

    private var categoryBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: event.category.iconName)
                .font(.caption2)
            Text(event.category.displayName)
                .font(.caption2.weight(.medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: Capsule())
    }
}
