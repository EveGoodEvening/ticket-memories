# Review Audit — Remediation Plan

Date: 2026-05-06
Source: `planning/review.planning.md`
Scope: Fix 23 over-marked `[x]` items + 1 under-marked `[ ]` item in `planning/init.todo.md`

---

## 0. How to Use This Todo

This document turns the review audit findings into an actionable remediation plan.

Each over-marked item gets one of four dispositions:

- **Unmark + Implement** — revert to `[ ]`, then build the feature properly
- **Unmark + Defer** — revert to `[ ]`, leave for post-MVP or a future sprint
- **Unmark + Remove toggle** — revert to `[ ]`, also remove the dead UI (toggles that control nothing)
- **Mark [x]** — for the 1 under-marked item that is already implemented

Priority levels:

- `P0` — Broken behavior that will confuse or harm users (e.g., video import silently corrupts data)
- `P1` — Feature gap visible to users (toggles that do nothing, missing disclaimers)
- `P2` — Quality/polish gap (accessibility, design system completeness)
- `P3` — Architectural/future-proofing gap (can safely defer to post-MVP)

---

## 1. Phase 1: Fix Broken Implementations (P0)

These items are actively broken — the UI promises something that doesn't work.

### 1.1 Video import pipeline corrupts videos

- **Review item #9** — `init.todo.md` line 921: `[x] Allow video selection if practical`
- **Problem:** `PhotosPicker` accepts `.videos`, but `importSelectedMedia` hardcodes `type: .image` and routes all data through `MediaStorageService.importImage` (image-only JPEG conversion). Selected videos are silently corrupted.
- **Disposition:** Unmark + Implement

Checklist:

- [x] Revert `init.todo.md` line 921 to `[ ]`
- [x] In `MediaGallerySection.swift`, detect video vs. image from `PhotosPickerItem` content type
- [x] Add `MediaStorageService.importVideo(data:eventId:)` that saves raw video data (no JPEG conversion)
- [x] Set `type: .video` on `MediaAsset` for video imports
- [x] Generate video thumbnail via `AVAssetImageGenerator` (fixes review item #8 simultaneously)
- [ ] Test: select a video from PhotosPicker → verify it saves as video, plays back, has thumbnail
- [ ] Mark `[x]` only after verified

### 1.2 Video thumbnails not generated

- **Review item #8** — `init.todo.md` line 887: `[x] Show video thumbnails`
- **Problem:** `MediaStorageService` only generates thumbnails for images via `UIImage`. No `AVAssetImageGenerator` for video frames.
- **Disposition:** Unmark + Implement (covered by 1.1 above)

Checklist:

- [x] Revert `init.todo.md` line 887 to `[ ]`
- [x] Add `generateVideoThumbnail(from url: URL) -> UIImage?` to `MediaStorageService`
- [x] Use `AVAssetImageGenerator` to extract first frame or frame at 1s
- [x] Call this during video import to populate `thumbnailPath`
- [ ] Mark `[x]` only after verified

---

## 2. Phase 2: Remove Dead UI / Fix Vacuous Toggles (P1)

These items have toggle UI that controls nothing. Users see options that are lies.

### 2.1 PDF "Include/exclude photos" toggle does nothing

- **Review item #15** — `init.todo.md` line 1168: `[x] Include/exclude photos`
- **Problem:** `PDFExportOptions.includePhotos` exists; toggle shown in UI. But `PDFExportService.renderEventPage` never checks `options.includePhotos` and never renders photos.
- **Disposition:** Unmark + Implement (decision: implement rendering)

Checklist:

- [x] Revert `init.todo.md` line 1168 to `[ ]`
- [x] In `PDFExportService.renderEventPage`, check `options.includePhotos`
- [x] Read event's `MediaAsset` images from disk, render a photo grid below notes section
- [x] Handle missing image files gracefully (skip, don't crash)
- [ ] Mark `[x]` only after the toggle controls real behavior

### 2.2 PDF "Include/exclude map" toggle does nothing

- **Review item #16** — `init.todo.md` line 1170: `[x] Include/exclude map`
- **Problem:** Same pattern — toggle exists, `PDFExportService` never renders a map page.
- **Disposition:** Unmark + Implement (decision: implement rendering)

Checklist:

- [x] Revert `init.todo.md` line 1170 to `[ ]`
- [x] In `PDFExportService`, add a `renderMapPage` method
- [x] Use `MKMapSnapshotter` to render a static map image with event pins
- [x] Gate the map page on `options.includeMap` and at least one event having coordinates
- [ ] Mark `[x]` only after the toggle controls real behavior

### 2.3 PDF "Include/exclude Spotify link" toggle does nothing

- **Review items #14, #17, #20** — `init.todo.md` lines 1171, 1258
  - Line 1171: `[x] Include/exclude Spotify link/QR placeholder`
  - Line 1258: `[x] Let user exclude Spotify link`
- **Problem:** Toggle exists, PDF renderer never renders any Spotify content. The exclusion toggle is vacuously true.
- **Disposition:** Unmark + Implement (decision: implement rendering)

Checklist:

- [x] Revert `init.todo.md` line 1171 to `[ ]`
- [x] Revert `init.todo.md` line 1258 to `[ ]`
- [x] In `PDFExportService.renderEventPage`, check `options.includeSpotifyLink`
- [x] When event has a `SpotifyPlaylistLink`, render the URL text on the event page
- [x] Optionally generate a QR code via `CIFilter("CIQRCodeGenerator")` for the Spotify URL
- [x] Gate rendering on `options.includeSpotifyLink` so the toggle actually works
- [x] Also mark `init.todo.md` line 735 (`[ ] Add optional Spotify link/QR placeholder`) as covered by this work
- [ ] Mark `[x]` only after the toggle controls real behavior

### 2.4 PDF "Select year" not in options sheet

- **Review item #18** — `init.todo.md` line 1164: `[x] Select year`
- **Problem:** The `printOptionsSheet` in `ExportView` has no year picker. Year comes implicitly from RecapView.
- **Disposition:** Unmark + Defer (decision: accept RecapView context, add read-only year display at most)

Checklist:

- [x] Revert `init.todo.md` line 1164 to `[ ]`
- [x] Add a read-only year label to `printOptionsSheet` so user sees which year they're exporting
- [x] No year picker needed — year is inherited from RecapView context

---

## 3. Phase 3: Implement Missing Features (P1)

### 3.1 Write import disclaimer

- **Review item #19** — `init.todo.md` line 1229: `[x] Write import disclaimer`
- **Problem:** Import flow has a description ("We'll extract the event details...") but no privacy/legal disclaimer about what data is extracted vs. discarded.
- **Disposition:** Unmark + Implement

Checklist:

- [x] Revert `init.todo.md` line 1229 to `[ ]`
- [x] Add a short disclaimer text to `ImportPassView.swift` below the description, e.g.: "Only event metadata (title, date, colors) is extracted. Barcodes, authentication tokens, and raw ticket credentials are never stored."
- [x] Use localized string key for the disclaimer
- [ ] Mark `[x]` after implemented

### 3.2 Expired pass handling

- **Review item #22** — `init.todo.md` line 1035: `[x] Expired pass`
- **Problem:** `PassImportService` never checks `PKPass.expirationDate`. Expired passes import fine by accident, not by design.
- **Disposition:** Unmark + Implement (lightweight)

Checklist:

- [x] Revert `init.todo.md` line 1035 to `[ ]`
- [x] In `PassImportService.importPass`, check `pass.expirationDate`
- [x] If expired: still allow import (it's a memory), but set a flag on `PassImportResult` like `isExpired: Bool`
- [x] In `ImportPassView`, show an informational note: "This pass has expired, but you can still save it as a memory."
- [ ] Mark `[x]` after implemented

### 3.3 Pass visuals fallback

- **Review item #23** — `init.todo.md` line 1037: `[x] Pass whose visuals cannot be extracted`
- **Problem:** `PassImportService` assigns `pass.icon` to `thumbnailData` with no nil-check. If `pass.icon` is nil, thumbnail is silently skipped.
- **Disposition:** Unmark + Implement (lightweight)

Checklist:

- [x] Revert `init.todo.md` line 1037 to `[ ]`
- [x] In `PassImportService.importPass`, after `result.thumbnailData = pass.icon`:
  - If nil, generate a fallback thumbnail using the pass's background color + organization name text
  - Or simply log and continue (current behavior) but add a note in the confirmation UI: "No pass image was found"
- [x] In `ImportPassView`, if no thumbnail: show category-colored placeholder instead of blank space
- [ ] Mark `[x]` after implemented

---

## 4. Phase 4: Accessibility Fixes (P2)

### 4.1 Dynamic Type support

- **Review item #3** — `init.todo.md` line 349: `[x] Support Dynamic Type at least for core screens`
- **Problem:** Multiple core screens use fixed `.system(size: 48/64/72)` fonts that don't scale with Dynamic Type settings.
- **Disposition:** Unmark + Implement

Files to fix:

- [x] Revert `init.todo.md` line 349 to `[ ]`
- [x] `TimelineEventCard.swift` — replace `.system(size: 48)` with `@ScaledMetric` variable
- [x] `MemoryDetailView.swift` — replace `.system(size: 64)` with `@ScaledMetric` variable
- [x] `ImportPassView.swift` — replace `.system(size: 64)` with `@ScaledMetric` variable
- [x] `OnboardingView.swift` — replace `.system(size: 72)` with `@ScaledMetric` variable
- [x] Use `@ScaledMetric` for any sizes that must remain numeric but should scale
- [ ] Test with Accessibility Inspector or Large Text setting on simulator
- [ ] Mark `[x]` after core screens verified

### 4.2 Tappable targets 44pt

- **Review item #4** — `init.todo.md` line 350: `[x] Ensure tappable targets are large enough`
- **Problem:** No systematic enforcement. Only incidental 44pt sizes on two icon images.
- **Disposition:** Unmark + Defer (SwiftUI default controls are generally fine; audit on real device before TestFlight)

Checklist:

- [x] Revert `init.todo.md` line 350 to `[ ]`
- [x] Add to QA checklist: audit tappable target sizes on physical device during TestFlight prep (deferred to TestFlight)
- [ ] Mark `[x]` only after physical device audit

### 4.3 Button styles

- **Review item #2** — `init.todo.md` line 334: `[x] Define button styles`
- **Problem:** No custom `ButtonStyle` structs defined. App uses system `.borderedProminent` etc.
- **Disposition:** Unmark + Defer (system button styles are fine for MVP)

Checklist:

- [x] Revert `init.todo.md` line 334 to `[ ]`
- [x] Evaluate during polish phase whether custom button styles are needed for visual consistency (deferred to polish phase)
- [x] If needed: add `PrimaryButtonStyle`, `SecondaryButtonStyle` to `DesignSystem.swift` (deferred: system styles fine for MVP)

---

## 5. Phase 5: Location Features (P2)

### 5.1 Location confidence never populated

- **Review item #10** — `init.todo.md` line 975: `[x] Store location confidence`
- **Problem:** `LocationConfidence` enum and `locationConfidence` field exist on `MemoryEvent`, but no UI or service ever sets it.
- **Disposition:** Unmark + Implement (lightweight, wire it up during create/edit/import)

Checklist:

- [x] Revert `init.todo.md` line 975 to `[ ]`
- [x] In `CreateMemoryView` / `EditMemoryView`: when user types venue/city text, set `.manual`
- [ ] In `PassImportService`: when location is extracted from pass, set `.inferred` (deferred: pass doesn't extract location currently)
- [ ] If geocoding is added later: set `.exact` for geocoded coordinates
- [x] Default remains `.unknown` (nil) when no location is provided
- [ ] Mark `[x]` after implemented

### 5.2 Location editing lacks coordinate support

- **Review items #11, #12** — `init.todo.md` lines 972-973, 1464, 1525
  - Line 972: `[x] Allow adding location from create/edit form`
  - Line 973: `[x] Allow changing location`
  - Line 1464: `[x] Add location fields/search` (Step 7 summary)
  - Line 1525: `[x] Location entry/search` (dependency)
- **Problem:** Only text fields for venue/city/country. No coordinate picker, no geocoding, no `MKLocalSearch`. The "search" part is entirely missing.
- **Disposition:** Unmark the search-related claims; the text fields ARE location entry, just not search

Checklist:

- [x] Revert `init.todo.md` line 1464 to `[ ]` (removed — search not implemented)
- [x] Revert `init.todo.md` line 1525 to `[ ]` (removed — search not implemented)
- [x] Lines 972-973 can stay `[x]` — text-based location adding/changing IS implemented
- [ ] Add new task under Section 7.2 GeocodingService: `[ ] Implement MKLocalSearch venue lookup` (deferred: location search is post-Batch 4)
- [ ] Add new task under Section 12.3: `[ ] Add coordinate picker or geocoding to create/edit form` (deferred: location search is post-Batch 4)
- [ ] Mark search tasks `[x]` only after `MKLocalSearch` or `CLGeocoder` is integrated

---

## 6. Phase 6: Defer to Post-MVP (P3)

These items should be unmarked but don't need implementation before TestFlight.

### 6.1 Deep links

- **Review item #1** — `init.todo.md` line 234: `[x] Ensure deep links/navigation routes can open a specific memory detail`
- **Problem:** No `onOpenURL`, URL scheme, or universal links. Only in-app `NavigationLink`.
- **Disposition:** Unmark + Defer (deep links are post-MVP; in-app navigation works fine)

Checklist:

- [x] Revert `init.todo.md` line 234 to `[ ]`
- [x] Move to post-MVP backlog or keep as `[ ]` in current section

### 6.2 Theme resource structure

- **Review item #5** — `init.todo.md` line 389: `[x] Add theme resource structure`
- **Problem:** Only `themeId: String = "classicTimeline"` on `AnnualRecap`. No theme files, enum, or config.
- **Disposition:** Unmark + Defer (theme system is post-MVP; one hardcoded template is fine for MVP)

Checklist:

- [x] Revert `init.todo.md` line 389 to `[ ]`
- [x] Implement when recap templates (Section 14.3) are built (deferred to post-MVP)

### 6.3 Generated artifact references

- **Review item #6** — `init.todo.md` line 539: `[x] Store generated artifact references`
- **Problem:** `ExportArtifact` model exists but is never instantiated. No export creates artifact records.
- **Disposition:** Unmark + Defer (export works without tracking artifacts; tracking is a nice-to-have)

Checklist:

- [x] Revert `init.todo.md` line 539 to `[ ]`
- [x] When implementing "Exported files management" (Settings, line 1269), wire up `ExportArtifact` creation in `ExportRenderer` and `PDFExportService` (deferred to post-MVP)

### 6.4 Info.plist usage strings

- **Review item #7** — `init.todo.md` line 394: `[x] Add Info.plist usage strings for permissions only when needed`
- **Problem:** No `Info.plist` file exists at all. Blocked by needing Xcode project setup on macOS.
- **Disposition:** Unmark + note as blocked

Checklist:

- [x] Revert `init.todo.md` line 394 to `[ ] Blocked: requires Xcode project setup on macOS`
- [x] When Xcode project is created: add `NSPhotoLibraryUsageDescription` and any other needed keys (blocked: needs macOS)

### 6.5 Avoid hard-coding paywall decisions

- **Review item #21** — `init.todo.md` line 1302: `[x] Avoid hard-coding paywall decisions into core components`
- **Problem:** No monetization code exists at all. Marked done by omission, not by architectural choice.
- **Disposition:** Unmark + Defer (revisit when monetization work begins in Phase 3 / TestFlight prep)

Checklist:

- [x] Revert `init.todo.md` line 1302 to `[ ]`
- [x] When implementing monetization (Section 19): add feature entitlement layer and verify no hard-coded gating (deferred to post-MVP)

---

## 7. Phase 7: Fix Under-Marked Item

### 7.1 Export files open outside app

- **Review under-marked item** — `init.todo.md` line 1547: `[ ] Export files open outside app`
- **Problem:** `ShareSheet` wrapping `UIActivityViewController` is fully implemented in `ExportView.swift`. Task should be `[x]`.
- **Disposition:** Mark `[x]`

Checklist:

- [x] Change `init.todo.md` line 1547 from `[ ]` to `[x]`

---

## 8. Execution Summary

### Batch 1: Immediate marking corrections (no code changes)

These can all be done in a single commit updating `init.todo.md`:

| Line | Current | New | Reason |
|------|---------|-----|--------|
| 234 | `[x]` | `[ ]` | No deep links exist |
| 334 | `[x]` | `[ ]` | No custom button styles |
| 349 | `[x]` | `[ ]` | Fixed font sizes, not Dynamic Type |
| 350 | `[x]` | `[ ]` | No 44pt enforcement |
| 389 | `[x]` | `[ ]` | No theme files exist |
| 394 | `[x]` | `[ ]` | No Info.plist exists (blocked) |
| 539 | `[x]` | `[ ]` | ExportArtifact never instantiated |
| 887 | `[x]` | `[ ]` | No video thumbnail generation |
| 921 | `[x]` | `[ ]` | Video pipeline broken |
| 975 | `[x]` | `[ ]` | Location confidence never set |
| 1035 | `[x]` | `[ ]` | No expiration check |
| 1037 | `[x]` | `[ ]` | No visual fallback |
| 1164 | `[x]` | `[ ]` | No year picker in PDF options |
| 1168 | `[x]` | `[ ]` | Toggle does nothing |
| 1170 | `[x]` | `[ ]` | Toggle does nothing |
| 1171 | `[x]` | `[ ]` | Toggle does nothing |
| 1229 | `[x]` | `[ ]` | No actual disclaimer |
| 1258 | `[x]` | `[ ]` | Toggle is vacuous |
| 1302 | `[x]` | `[ ]` | No monetization code exists |
| 1464 | `[x]` | `[ ]` | Search not implemented |
| 1525 | `[x]` | `[ ]` | Search not implemented |
| 1547 | `[ ]` | `[x]` | ShareSheet is implemented |

Total: 21 reverts to `[ ]`, 1 mark to `[x]`

### Batch 2: P0 — Fix broken video pipeline

Files to modify:
- `TicketMemories/Features/MemoryDetail/MediaGallerySection.swift`
- `TicketMemories/Services/MediaStorageService.swift`

Estimated scope: ~50-80 lines of new code

### Batch 3: P1 — Implement PDF rendering + import hardening

Files to modify:
- `TicketMemories/Services/PDFExportService.swift` (add photo grid, map page, Spotify link/QR rendering)
- `TicketMemories/Features/Import/ImportPassView.swift` (add disclaimer, expired pass note, visual fallback)
- `TicketMemories/Services/PassImportService.swift` (add expiration check, icon fallback)

Decision resolved: implement the PDF features (~200 lines). Toggles stay and get wired to real rendering.

### Batch 4: P2 — Accessibility + location confidence

Files to modify:
- `TicketMemories/Features/Timeline/TimelineEventCard.swift`
- `TicketMemories/Features/MemoryDetail/MemoryDetailView.swift`
- `TicketMemories/Features/Import/ImportPassView.swift`
- `TicketMemories/Features/Onboarding/OnboardingView.swift`
- `TicketMemories/Features/MemoryDetail/CreateMemoryView.swift`
- `TicketMemories/Features/MemoryDetail/EditMemoryView.swift`

Estimated scope: ~30-40 lines changed (font replacements + confidence assignments)

### Batch 5: P3 — No code changes, just marking corrections (covered in Batch 1)

---

## 9. Decision Points (Resolved)

- [x] **PDF photos/map/Spotify**: Implement rendering in PDF, or strip the dead toggles for now?
  - **Decision: Implement rendering in PDF.** The toggles stay; wire them up to real rendering in `PDFExportService`.
- [x] **Location search**: Build `MKLocalSearch` now, or defer?
  - **Decision: Defer.** Location search is a larger feature; defer to post-Batch 4.
- [x] **Year picker in PDF options**: Add a year picker to the options sheet, or accept RecapView context?
  - **Decision: Accept RecapView context.** Add a read-only year display to the options sheet at most.
