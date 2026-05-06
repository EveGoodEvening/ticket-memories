# Ticket Memories

Turn your event tickets into a personal timeline of memories. Ticket Memories is an iOS app that helps you organize concerts, music festivals, exhibitions, travel, sports, and theater experiences into a beautiful timeline, map, and annual recap.

## What It Does

- **Import tickets** from `.pkpass` files or create memories manually
- **Timeline** — browse your events chronologically with large, image-led cards
- **Map** — see every event pinned on a map, filterable by year and category
- **Annual Recap** — generate a shareable year-in-review image or PDF with stats, photos, and a Spotify playlist
- **Media** — attach photos, videos, and notes to each memory
- **Spotify** — link a playlist to any event
- **Export** — share event cards and recaps as images or print-ready PDFs

Data stays on your device by default. No account required.

## Categories

| Category | Icon |
|---|---|
| Concert | `music.mic` |
| Music Festival | `music.note.list` |
| Exhibition | `paintpalette` |
| Travel | `airplane` |
| Sports | `sportscourt` |
| Theater | `theatermasks` |
| Other | `ticket` |

## Tech Stack

- **SwiftUI** + **SwiftData**
- **MapKit** for event pins
- **PhotosUI** for media selection
- **AVKit** for video
- **PassKit** for `.pkpass` parsing
- **PDFKit / CoreGraphics** for export rendering

## Requirements

- macOS with Xcode (latest stable)
- iOS 17.0+
- Swift 5.9+

## Building

The repository contains Swift source files under `TicketMemories/` and tests under `TicketMemoriesTests/`. There is no `.xcodeproj` or `Package.swift` checked in yet.

**Option A — Xcode project:**

1. Open Xcode and create a new **App** project (iOS, SwiftUI).
2. Drag the `TicketMemories/` folder into the project navigator.
3. Add `TicketMemoriesTests/` as a test target.
4. Build and run with **Cmd+R**.

**Option B — Swift Package:**

1. Add a `Package.swift` at the repo root.
2. Build from the command line:
   ```bash
   xcodebuild -scheme TicketMemories -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

## Project Structure

```
TicketMemories/
  App/                  # App entry point, router, design system
  Models/               # MemoryEvent, PassSnapshot, MediaAsset, etc.
  Features/
    Timeline/           # Chronological event feed
    MemoryDetail/       # Event detail, edit, and create views
    Import/             # .pkpass file import
    Map/                # Map view with event pins
    Recap/              # Annual recap generation
    Export/             # Image and PDF export
    Onboarding/         # First-launch experience
    Settings/           # App settings
  Services/             # Pass import, media storage, PDF export, Spotify, recap
  Resources/            # Assets
```

## Privacy

- All data is stored locally on device.
- Sensitive ticket credentials (barcodes, auth tokens) are not stored by default.
- Photos and location are only accessed when you choose to add them.
- Sharing is opt-in with full preview before export.

## License

All rights reserved.
