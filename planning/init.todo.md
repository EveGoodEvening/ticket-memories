# Ticket Memories 初始化 Todo / Checklist

Date: 2026-05-06
Source plan: `planning/init.planning.md`
Scope: iOS local-first MVP planning checklist only. No implementation has started.

## 0. How to Use This Todo

This document turns the product plan into an implementation-ready checklist.

Conventions:

- `[ ]` Not started
- `[~]` In progress
- `[x]` Done
- `MVP` Required for first usable build
- `Post-MVP` Later, not required for initial release
- `Blocked` Requires earlier work or external decision

Primary MVP promise:

> User can create/import an event memory, attach photos/notes/Spotify link, view it in a beautiful timeline and map, generate annual recap, and export image/PDF including print-ready PDF.

Hard constraints:

- Do not promise automatic reading of all Wallet passes.
- Do not build public share URLs in MVP.
- Do not build physical order fulfillment in MVP.
- Do not build a backend in MVP.
- Do not request broad permissions during onboarding.
- Do not store or upload raw ticket credentials by default.

---

## 1. Milestone Overview

### M0: Product and Design Foundation

Goal: clarify visual direction, app flow, data model, privacy posture, and localization structure before code expands.

Exit criteria:

- App information architecture is finalized.
- MVP screen list is finalized.
- Categories and stable IDs are finalized.
- Privacy copy and import disclaimers are drafted.
- Design direction for timeline and recap is chosen.

### M1: Project Bootstrap

Goal: create a working iOS app shell with SwiftUI, SwiftData, navigation, local resources, and placeholder data.

Exit criteria:

- App launches.
- Main tabs or navigation shell exists.
- SwiftData container is configured.
- Localizable string structure exists.
- Sample memory data can render in preview or debug mode.

### M2: Manual Memory Creation Loop

Goal: user can manually create, edit, and view event memories.

Exit criteria:

- User can create a memory with title/category/date/location.
- Created memory appears in timeline.
- User can open memory detail.
- User can edit or delete memory.

### M3: Beautiful Timeline MVP

Goal: timeline becomes the main emotional product surface.

Exit criteria:

- Memories are grouped by year/month.
- Timeline cards look polished.
- Empty state guides first import/create.
- Category styling is visible.
- Timeline performs acceptably with test data.

### M4: Detail, Media, Notes, Spotify

Goal: each memory becomes rich enough to feel like a personal keepsake.

Exit criteria:

- User can add photos/videos.
- User can write notes.
- User can add Spotify playlist URL.
- User can pick/change cover image.
- Detail page handles empty and rich states gracefully.

### M5: Map MVP

Goal: memories with coordinates appear on a map.

Exit criteria:

- Event pins render.
- User can filter by year/category.
- User can tap pin and open memory detail.
- Events without coordinates do not break map.

### M6: `.pkpass` Import MVP

Goal: user can import a selected `.pkpass` file and convert safe metadata into a memory.

Exit criteria:

- User can select `.pkpass` file.
- App parses safe metadata where possible.
- App shows confirmation/edit screen before saving.
- Invalid import produces clear error.
- Sensitive ticket credential storage is avoided by default.

### M7: Annual Recap MVP

Goal: user can generate a visually compelling yearly recap.

Exit criteria:

- User can pick a year.
- App computes recap stats.
- At least one polished recap template renders.
- Recap can handle sparse data.
- Recap includes photos/map/category stats when available.

### M8: Export and Print-ready PDF MVP

Goal: user can export shareable assets without backend.

Exit criteria:

- Single event card image export works.
- Annual recap image export works.
- Annual recap PDF export works.
- Print-ready PDF initial template works.
- Native share sheet / save-to-Files flow works.

### M9: Polish, QA, TestFlight Prep

Goal: app is stable enough for real testers.

Exit criteria:

- Critical user flows manually tested.
- Edge cases handled.
- Privacy copy reviewed.
- Empty states polished.
- TestFlight build can be produced.

---

## 2. Product Decisions Checklist

### 2.1 Language and Localization

- [x] Decide MVP display language: Chinese, English, or bilingual. → English MVP, bilingual localization structure.
- [x] Use stable category IDs independent of UI language.
- [x] Use stable theme IDs independent of UI language.
- [x] Add localization resource structure from project bootstrap.
- [x] Ensure exported recap/PDF strings come from localization resources.
- [x] Avoid storing localized strings as persistent enum values.
- [x] Verify category display names can switch language later without data migration.

Acceptance criteria:

- Changing UI language later does not require changing persisted event data.
- Categories and themes are stored as stable IDs.

### 2.2 Category Scope

MVP categories:

- [x] `concert` / 演唱会
- [x] `musicFestival` / 音乐节
- [x] `exhibition` / 展览
- [x] `travel` / 旅行
- [x] `sports` / 体育赛事
- [x] `theater` / 剧场, optional but model-ready
- [x] `other` / 其他

Category checklist:

- [x] Define icon for each category.
- [x] Define color for each category.
- [x] Define fallback cover treatment for each category.
- [x] Define localized display name for each category.
- [x] Ensure all categories use the same underlying `MemoryEvent` model.
- [x] Avoid category-specific data models in MVP.

Acceptance criteria:

- Adding a new category later requires only adding enum/config/localized strings/assets, not redesigning core model.

### 2.3 MVP Non-goals Guardrail

Before implementing a feature, verify it does not accidentally introduce these:

- [x] No automatic Wallet-wide pass scanning.
- [x] No public share URL.
- [x] No backend dependency.
- [x] No user account requirement.
- [x] No social graph.
- [x] No physical print order checkout.
- [x] No CloudKit sync in MVP unless explicitly moved into scope.
- [x] No Spotify OAuth in MVP unless pasted URL flow proves insufficient.
- [x] No raw barcode upload.

---

## 3. UX and Information Architecture Todo

### 3.1 App Navigation

Recommended main navigation:

- Timeline
- Map
- Recap
- Settings

Checklist:

- [x] Decide whether to use TabView or navigation-first home screen. → TabView.
- [x] Make Timeline the default landing surface.
- [x] Add primary create/import action accessible from Timeline.
- [x] Add Map as secondary exploration surface.
- [x] Add Recap as explicit feature surface.
- [x] Add Settings for privacy/export/app info.
- [x] Ensure deep links/navigation routes can open a specific memory detail.

Acceptance criteria:

- New user understands how to create first memory within 10 seconds.
- Returning user lands on meaningful timeline content.

### 3.2 Onboarding Flow

Screens:

1. Welcome
2. Privacy promise
3. Create/import first memory

Checklist:

- [x] Draft welcome headline. → “Your Events, Your Story”
- [x] Draft one-sentence value proposition. → “Turn your tickets into a personal timeline of memories.”
- [x] Draft privacy promise copy. → “Your memories stay on your device. You choose what to import and share.”
- [x] Explain user-selected import model.
- [x] Avoid claiming automatic Wallet import.
- [x] Add CTA: “Create Memory”.
- [ ] Add CTA: “Import .pkpass”.
- [ ] Add skip option if needed.
- [x] Do not request Photos permission until user adds media.
- [x] Do not request Location permission during onboarding.
- [x] Do not request Spotify authorization during onboarding.
- [x] Do not request iCloud permission during onboarding.

Acceptance criteria:

- Onboarding sets correct expectations and immediately funnels into first memory creation/import.

### 3.3 Empty States

Timeline empty state:

- [x] Explain what Ticket Memories does.
- [x] Offer “Create manually”.
- [ ] Offer “Import .pkpass”.
- [x] Mention user chooses what to import.

Map empty state:

- [x] Explain map needs memories with locations.
- [ ] Link to create/import memory.
- [ ] Link to edit existing memory locations if memories exist without coordinates.

Recap empty state:

- [x] Explain recap needs events in a selected year.
- [x] Suggest creating first event.
- [ ] Show sample/preview if no real data exists.

Export empty state:

- [ ] If no exportable content, explain what is missing.

Acceptance criteria:

- Every empty screen teaches the user what to do next.

---

## 4. Visual Design Todo

### 4.1 Design Direction

Target feeling:

- Emotional
- Premium
- Personal
- Memory-book-like
- Not generic utility app
- Not a plain Wallet clone

Checklist:

- [x] Define visual moodboard direction. → Emotional, premium, memory-book-like.
- [x] Choose typography style for dates and titles. → SF Rounded for titles, SF Pro for body.
- [x] Choose ticket-card visual language. → Rounded corners, subtle shadow, pass-like proportions.
- [x] Choose color system for categories. → See decisions.md for hex values.
- [x] Choose timeline spacing and card proportions. → Large image-led cards, generous spacing.
- [ ] Choose recap visual templates.
- [x] Decide whether MVP uses light mode only first or supports dark mode immediately. → Dark mode from MVP.
- [x] Define fallback visuals when no photos/pass images exist. → Category-colored gradient with icon.

Acceptance criteria:

- Timeline and recap look good even with manually created memories and no pass image.

### 4.2 Design System Basics

- [x] Define spacing scale.
- [x] Define corner radius scale.
- [x] Define shadow/elevation style.
- [x] Define category colors.
- [ ] Define semantic colors.
- [x] Define button styles.
- [x] Define card styles.
- [x] Define empty state component.
- [x] Define event card component.
- [ ] Define compact event preview card.
- [ ] Define ticket snapshot component.
- [ ] Define map marker style.
- [ ] Define recap stat tile style.

Acceptance criteria:

- New screens can reuse existing visual primitives without drifting visually.

### 4.3 Accessibility and Layout

- [x] Support Dynamic Type at least for core screens.
- [x] Ensure tappable targets are large enough.
- [ ] Ensure timeline cards have accessible labels.
- [ ] Ensure map markers have useful accessibility labels.
- [ ] Ensure recap export does not depend only on color.
- [ ] Verify text contrast.
- [x] Verify long event titles wrap cleanly.
- [ ] Verify non-English text fits layouts.

---

## 5. Project Bootstrap Todo

### 5.1 Repository and Project Setup

- [x] Create iOS app project.
- [x] Choose minimum iOS version. → iOS 17.0
- [x] Confirm Swift version. → 5.9+
- [x] Configure app name: Ticket Memories.
- [ ] Configure bundle identifier. Blocked: requires Xcode project setup on macOS.
- [x] Configure app icon placeholder.
- [ ] Configure launch screen. Blocked: requires Xcode project setup on macOS.
- [x] Add SwiftUI app entry point.
- [x] Add basic navigation shell.
- [x] Add local preview/sample data support.
- [ ] Add build scheme. Blocked: requires Xcode project setup on macOS.
- [ ] Add basic unit test target. Blocked: requires Xcode project setup on macOS.
- [ ] Add basic UI test target if practical. Blocked: requires Xcode project setup on macOS.

Acceptance criteria:

- App builds and launches on simulator.
- App shows timeline shell with empty/sample state.

### 5.2 Resources Setup

- [x] Add asset catalog.
- [x] Add category icons. → Using SF Symbols.
- [ ] Add placeholder cover assets.
- [x] Add localization file or string catalog. → Localizable.xcstrings with en/zh-Hans.
- [x] Add theme resource structure.
- [x] Add sample data fixtures for previews.

### 5.3 App Configuration

- [x] Add Info.plist usage strings for permissions only when needed.
- [x] Add file import support for `.pkpass` later in import milestone.
- [x] Avoid adding unnecessary entitlements in MVP.
- [x] Avoid adding CloudKit entitlement before sync work.
- [x] Avoid adding Spotify URL schemes until Spotify link/open behavior is implemented.

---

## 6. Data Model Todo

### 6.1 Model Definitions

Create SwiftData models or equivalent domain structs for:

- [x] `MemoryEvent`
- [x] `PassSnapshot`
- [x] `MediaAsset`
- [x] `SpotifyPlaylistLink`
- [x] `AnnualRecap`
- [x] `ExportArtifact`

### 6.2 `MemoryEvent` Checklist

Fields:

- [x] `id`
- [x] `title`
- [x] `category`
- [x] `startDate`
- [x] `endDate`
- [x] `timezoneIdentifier`
- [x] `venueName`
- [x] `address`
- [x] `city`
- [x] `country`
- [x] `latitude`
- [x] `longitude`
- [x] `locationConfidence`
- [x] `notes`
- [x] `tags`
- [x] `coverMediaId`
- [x] `source`
- [x] `isFavorite`
- [x] `createdAt`
- [x] `updatedAt`

Validation rules:

- [x] Title is required.
- [x] Category is required.
- [x] Date is recommended but should support unknown date if needed.
- [x] Location can be missing.
- [x] Coordinates can be missing.
- [x] `updatedAt` changes on edit.

### 6.3 `PassSnapshot` Checklist

Fields:

- [x] `id`
- [x] `eventId`
- [x] `organizationName`
- [x] `localizedName`
- [x] `localizedDescription`
- [x] `serialNumberHash`
- [x] `passTypeIdentifierHash`
- [x] `relevantDate`
- [x] `passURL`
- [x] `thumbnailImagePath`
- [x] `foregroundColor`
- [x] `backgroundColor`
- [x] `labelColor`
- [x] `barcodeStoredPolicy`
- [x] `createdAt`

Security tasks:

- [x] Hash pass identifiers for duplicate detection.
- [x] Do not persist raw authentication token.
- [x] Do not persist raw barcode payload in MVP.
- [x] Add explicit enum for barcode storage policy.

### 6.4 `MediaAsset` Checklist

Fields:

- [x] `id`
- [x] `eventId`
- [x] `type`
- [x] `localFilePath`
- [x] `thumbnailPath`
- [x] `originalFilename`
- [x] `capturedAt`
- [x] `latitude`
- [x] `longitude`
- [x] `duration`
- [x] `width`
- [x] `height`
- [x] `createdAt`
- [x] `updatedAt`

Behavior:

- [x] Support image.
- [x] Support video.
- [x] Support thumbnail path.
- [x] Support missing metadata.

### 6.5 `SpotifyPlaylistLink` Checklist

Fields:

- [x] `id`
- [x] `eventId`
- [x] `spotifyURI`
- [x] `externalURL`
- [x] `name`
- [x] `ownerName`
- [x] `imageURL`
- [x] `trackCount`
- [x] `linkedAt`

MVP behavior:

- [x] Store pasted Spotify playlist URL.
- [ ] Normalize Spotify URL/URI if possible.
- [ ] Validate basic Spotify URL format.
- [ ] Allow opening Spotify link externally.

### 6.6 `AnnualRecap` Checklist

Fields:

- [x] `id`
- [x] `year`
- [x] `title`
- [x] `themeId`
- [x] `generatedAt`
- [x] `coverImagePath`
- [x] `shareImagePath`
- [x] `pdfPath`
- [x] `statsJSON`

Behavior:

- [x] Store generated artifact references.
- [ ] Regenerate when memories change.
- [ ] Handle missing export files gracefully.

### 6.7 `ExportArtifact` Checklist

Fields:

- [x] `id`
- [x] `type`
- [x] `eventId`
- [x] `recapId`
- [x] `localFilePath`
- [x] `format`
- [x] `createdAt`

Types:

- [x] `eventCardImage`
- [x] `annualRecapImage`
- [x] `annualRecapPDF`
- [x] `printReadyPDF`

### 6.8 Model Tests

- [ ] Test create memory.
- [ ] Test edit memory.
- [ ] Test delete memory.
- [ ] Test query by year.
- [ ] Test query by category.
- [ ] Test query memories with coordinates.
- [ ] Test duplicate pass hash detection.
- [ ] Test export artifact cleanup behavior.

---

## 7. Services Todo

### 7.1 `MediaStorageService`

Responsibilities:

- Copy selected media into app storage.
- Generate thumbnails.
- Return `MediaAsset` metadata.
- Delete media files when asset is removed.

Checklist:

- [ ] Define app media directory structure.
- [ ] Implement image copy/import plan.
- [ ] Implement video copy/import plan.
- [ ] Implement thumbnail generation plan.
- [ ] Handle filename collisions.
- [ ] Handle large files.
- [ ] Handle import cancellation.
- [ ] Handle missing source file errors.
- [ ] Add cleanup for orphaned media files.

Acceptance criteria:

- Added media persists across app relaunch.
- Removing media removes or dereferences stored file safely.

### 7.2 `GeocodingService`

Responsibilities:

- Search venue/address.
- Convert user-selected location to coordinate.
- Store confidence.

Checklist:

- [ ] Decide MapKit local search API usage.
- [ ] Build venue search UI integration plan.
- [ ] Store selected coordinate.
- [ ] Support manual text-only location.
- [ ] Support no-location events.
- [ ] Avoid requiring current user location.

Acceptance criteria:

- User can create location-bearing memory without granting location permission.

### 7.3 `PassImportService`

Responsibilities:

- Import `.pkpass` file selected by user.
- Parse with PassKit where possible.
- Extract safe metadata.
- Produce draft memory for confirmation.

Checklist:

- [ ] Define import result type.
- [ ] Define import error type.
- [ ] Parse `PKPass` from file data.
- [ ] Extract localized name.
- [ ] Extract organization name.
- [ ] Extract localized description.
- [ ] Extract relevant date.
- [ ] Extract display colors where available.
- [ ] Extract icon/thumbnail if available.
- [ ] Hash pass identifiers.
- [ ] Avoid storing raw barcode payload.
- [ ] Avoid storing authentication token.
- [ ] Return editable draft rather than saving directly.

Acceptance criteria:

- Import never saves event without user confirmation.
- Invalid file shows recoverable error.

### 7.4 `SpotifyLinkService`

Responsibilities:

- Validate and normalize pasted Spotify URLs.
- Open Spotify link.
- Optionally fetch public metadata later.

Checklist:

- [ ] Accept playlist URLs.
- [ ] Extract playlist ID where possible.
- [ ] Normalize to URI/external URL.
- [ ] Reject clearly invalid URLs with helpful message.
- [ ] Open link externally.
- [ ] Defer OAuth to Post-MVP unless needed.

### 7.5 `RecapGenerator`

Responsibilities:

- Calculate year stats.
- Select highlight memories/photos.
- Generate recap view model.

Checklist:

- [ ] Query memories by year.
- [ ] Count events.
- [ ] Count cities.
- [ ] Count countries.
- [ ] Count categories.
- [ ] Determine favorite city.
- [ ] Determine favorite venue.
- [ ] Determine first event.
- [ ] Determine last event.
- [ ] Select highlight photos.
- [ ] Calculate map bounds.
- [ ] Handle sparse year with 1 event.
- [ ] Handle year with no located events.

Acceptance criteria:

- Recap generates useful output for 1, 3, 10, and 50 events.

### 7.6 `ExportRenderer`

Responsibilities:

- Render SwiftUI views to images.
- Support event card and recap image export.

Checklist:

- [ ] Define export image sizes.
- [ ] Define event card aspect ratios.
- [ ] Define recap long-image size.
- [ ] Render at high enough resolution.
- [ ] Save export artifact locally.
- [ ] Present share sheet.
- [ ] Handle export errors.

### 7.7 `PDFExportService`

Responsibilities:

- Generate annual recap PDF.
- Generate print-ready PDF.

Checklist:

- [ ] Define supported page sizes: A4, Letter.
- [ ] Define margins.
- [ ] Define image compression policy.
- [ ] Define page templates.
- [ ] Add cover page.
- [ ] Add stats page.
- [ ] Add map page if location data exists.
- [ ] Add event pages.
- [ ] Add media grid pages.
- [ ] Add optional notes.
- [ ] Add optional Spotify link/QR placeholder.
- [ ] Save PDF locally.
- [ ] Share/export PDF.
- [ ] Test print readability.

Acceptance criteria:

- Generated PDF can be opened in Files and previewed outside the app.

---

## 8. Manual Memory Creation Todo

### 8.1 Create Form

Required fields:

- [x] Title
- [x] Category

Recommended fields:

- [x] Start date
- [x] Venue/location
- [x] City/country

Optional fields:

- [x] End date
- [x] Notes
- [ ] Tags
- [x] Favorite

Form tasks:

- [x] Build create-memory screen.
- [x] Add title field.
- [x] Add category picker.
- [x] Add date picker.
- [x] Add optional end date.
- [x] Add venue field.
- [x] Add city/country fields.
- [ ] Add location search entry point.
- [x] Add notes field.
- [x] Add validation.
- [x] Add save action.
- [x] Add cancel action.
- [ ] Add loading/error state if location search is async.

Acceptance criteria:

- User can create a valid memory with only title/category/date.
- User can create a richer memory with location and notes.

### 8.2 Edit Form

- [x] Reuse create form where practical.
- [x] Load existing values.
- [x] Save edits.
- [x] Cancel edits.
- [x] Confirm destructive delete.
- [x] Update `updatedAt` on save.
- [x] Preserve media/pass links when editing basic metadata.

### 8.3 Delete Behavior

- [x] Add delete memory action.
- [x] Confirm before deleting.
- [x] Decide whether deleting memory deletes media files. → Cascade delete via SwiftData relationship.
- [x] Delete related pass snapshot.
- [x] Delete related Spotify link.
- [x] Delete related export artifacts or mark stale.
- [ ] Test timeline/map update after delete.

---

## 9. Timeline Todo

### 9.1 Data Grouping

- [x] Query memories sorted by date descending.
- [x] Group memories by year.
- [ ] Group memories by month.
- [x] Handle unknown-date memories.
- [x] Decide placement for unknown-date memories. → Grouped under "Unknown Date" at the end.
- [ ] Support filtering by category later if needed.

### 9.2 Timeline UI

- [x] Build timeline screen.
- [x] Build year section header.
- [ ] Build month section header.
- [x] Build large event card.
- [ ] Build compact fallback card.
- [ ] Show cover photo if present.
- [ ] Show pass snapshot if present.
- [x] Show category fallback art if no image.
- [x] Show event title.
- [x] Show date.
- [x] Show venue/city.
- [x] Show category marker.
- [x] Show favorite indicator.
- [x] Add tap to detail.
- [x] Add create/import button.

### 9.3 Timeline Polish

- [ ] Add smooth scrolling behavior.
- [ ] Test with 0 events.
- [ ] Test with 1 event.
- [ ] Test with 10 events.
- [ ] Test with 100 events.
- [ ] Test long titles.
- [ ] Test missing cover image.
- [ ] Test missing dates.
- [ ] Test dark mode if supported.

Acceptance criteria:

- Timeline feels like the product’s main emotional surface, not a database list.

---

## 10. Memory Detail Todo

### 10.1 Detail Layout

Sections:

- [x] Hero cover
- [x] Title/category/date
- [x] Venue/location
- [ ] Pass snapshot
- [ ] Media gallery
- [x] Notes
- [ ] Spotify playlist
- [ ] Map preview
- [ ] Export/share actions

Tasks:

- [x] Build detail screen.
- [x] Add edit button.
- [x] Add delete action.
- [x] Add favorite toggle.
- [ ] Add cover image selection.
- [ ] Add empty states per section.
- [x] Add scroll layout for long content.

### 10.2 Media Gallery

- [ ] Show image thumbnails.
- [ ] Show video thumbnails.
- [ ] Tap media to preview.
- [ ] Add media button.
- [ ] Remove media action.
- [ ] Change cover action.
- [ ] Handle missing media file.
- [ ] Handle large media collection.

### 10.3 Notes

- [x] Add notes editor.
- [x] Support multiline notes.
- [x] Preserve line breaks.
- [ ] Handle long notes.
- [ ] Show notes in PDF export if enabled.

### 10.4 Spotify Link

- [ ] Add Spotify URL input.
- [ ] Validate URL.
- [ ] Save link.
- [ ] Show playlist card.
- [ ] Open playlist externally.
- [ ] Remove playlist link.
- [ ] Handle invalid link gracefully.

---

## 11. Media Attachment Todo

### 11.1 PhotosPicker Integration

- [ ] Add photo picker entry point from detail page.
- [ ] Allow multiple image selection.
- [ ] Allow video selection if practical.
- [ ] Copy selected media into app storage.
- [ ] Generate thumbnails.
- [ ] Create `MediaAsset` records.
- [ ] Set first added media as cover if no cover exists.
- [ ] Avoid requesting full Photos access at launch.

### 11.2 Media Metadata

- [ ] Read captured date when available.
- [ ] Read dimensions.
- [ ] Read duration for video.
- [ ] Read location metadata if available and permitted.
- [ ] Do not require metadata for successful import.

### 11.3 Media Error Handling

- [ ] Handle user cancellation.
- [ ] Handle unsupported media.
- [ ] Handle file copy failure.
- [ ] Handle thumbnail failure.
- [ ] Handle storage full or write failure.

---

## 12. Map Todo

### 12.1 Map Data

- [ ] Query events with latitude and longitude.
- [ ] Exclude events without coordinates.
- [ ] Build map annotation model.
- [ ] Calculate initial map region.
- [ ] Handle one located event.
- [ ] Handle many located events.
- [ ] Handle no located events.

### 12.2 Map UI

- [ ] Build Map screen.
- [ ] Add event markers.
- [ ] Style markers by category.
- [ ] Add selected marker state.
- [ ] Add bottom preview card.
- [ ] Tap preview to detail.
- [ ] Add year filter.
- [ ] Add category filter.
- [ ] Add reset filters action.

### 12.3 Location Editing

- [ ] Allow adding location from create/edit form.
- [ ] Allow changing location.
- [ ] Allow removing exact coordinates.
- [ ] Store location confidence.
- [ ] Let text-only location remain without coordinate.

Acceptance criteria:

- Map works without location permission because it displays stored event locations, not current user location.

---

## 13. `.pkpass` Import Todo

### 13.1 File Import UI

- [ ] Add import button from empty timeline.
- [ ] Add import button from main create/import action.
- [ ] Configure file picker for `.pkpass` if supported.
- [ ] Handle file picker cancellation.
- [ ] Show importing state.
- [ ] Show import failure state.

### 13.2 Pass Parsing

- [ ] Read selected file data.
- [ ] Create `PKPass` from data where possible.
- [ ] Extract localized name.
- [ ] Extract organization name.
- [ ] Extract localized description.
- [ ] Extract relevant date.
- [ ] Extract pass URL if available.
- [ ] Extract display image/icon if available.
- [ ] Extract pass display colors if available.
- [ ] Hash pass type identifier.
- [ ] Hash serial number.
- [ ] Avoid raw barcode persistence.
- [ ] Avoid authentication token persistence.

### 13.3 Draft Confirmation

- [ ] Convert import result to editable draft.
- [ ] Show title field prefilled if available.
- [ ] Show date prefilled if available.
- [ ] Show location prefilled if available.
- [ ] Let user choose category.
- [ ] Let user edit all imported fields.
- [ ] Save only after confirmation.
- [ ] Create linked `PassSnapshot`.

### 13.4 Duplicate Handling

- [ ] Compute pass hash.
- [ ] Detect existing pass snapshot with same hash.
- [ ] Show duplicate warning.
- [ ] Let user cancel or create duplicate intentionally.

### 13.5 Import Edge Cases

- [ ] Invalid file.
- [ ] Valid pass with no date.
- [ ] Valid pass with no location.
- [ ] Valid pass with non-English strings.
- [ ] Expired pass.
- [ ] Pass with multiple relevant dates.
- [ ] Pass whose visuals cannot be extracted.

Acceptance criteria:

- `.pkpass` import is useful but never required; manual creation remains reliable fallback.

---

## 14. Recap Todo

### 14.1 Recap Entry Surface

- [ ] Add Recap tab/screen.
- [ ] Let user select year.
- [ ] Show available years from memories.
- [ ] Show empty state for no memories.
- [ ] Show preview for selected year.
- [ ] Add regenerate action.
- [ ] Add export action.

### 14.2 Recap Stats

- [ ] Total events.
- [ ] Total cities.
- [ ] Total countries.
- [ ] Category distribution.
- [ ] Favorite city.
- [ ] Favorite venue.
- [ ] First event.
- [ ] Last event.
- [ ] Map bounds.
- [ ] Highlight media count.

### 14.3 Recap Templates

MVP templates:

- [ ] Classic Timeline
- [ ] Festival Poster
- [ ] Map Diary

For each template:

- [ ] Define layout.
- [ ] Define color behavior.
- [ ] Define typography.
- [ ] Define empty data fallback.
- [ ] Define image placement.
- [ ] Define export size.
- [ ] Test with 1 event.
- [ ] Test with 5 events.
- [ ] Test with 20 events.

### 14.4 Recap Content Selection

- [ ] Choose highlight events.
- [ ] Choose highlight photos.
- [ ] Prefer favorite events if available.
- [ ] Prefer events with cover images.
- [ ] Avoid showing too many events in one export.
- [ ] Allow manual selection later if needed.

Acceptance criteria:

- User can generate a good-looking recap without manually designing it.

---

## 15. Export Todo

### 15.1 Event Card Image Export

- [ ] Define event card export size.
- [ ] Include title.
- [ ] Include date.
- [ ] Include venue/city.
- [ ] Include category.
- [ ] Include cover/pass visual.
- [ ] Include subtle app branding if desired.
- [ ] Render image.
- [ ] Save to temporary or exports directory.
- [ ] Open share sheet.

### 15.2 Annual Recap Image Export

- [ ] Define long image export size.
- [ ] Render selected recap template.
- [ ] Include year stats.
- [ ] Include map if available.
- [ ] Include photos if available.
- [ ] Save image.
- [ ] Open share sheet.

### 15.3 Annual Recap PDF Export

- [ ] Define PDF page size.
- [ ] Add cover page.
- [ ] Add stats page.
- [ ] Add selected recap view.
- [ ] Add selected events summary.
- [ ] Save PDF.
- [ ] Open share sheet.

### 15.4 Export Error Handling

- [ ] Handle rendering failure.
- [ ] Handle file write failure.
- [ ] Handle missing media file.
- [ ] Handle no exportable events.
- [ ] Show user-friendly error message.

---

## 16. Print-ready PDF Todo

### 16.1 Print Product Scope

MVP print-ready PDF only. No order checkout.

- [ ] Do not integrate print vendor.
- [ ] Do not collect shipping address.
- [ ] Do not collect payment for physical goods.
- [ ] Do not build fulfillment status.
- [ ] Generate local PDF only.

### 16.2 PDF Options UI

- [ ] Select year.
- [ ] Select events.
- [ ] Select template.
- [ ] Select page size: A4 / Letter.
- [ ] Include/exclude photos.
- [ ] Include/exclude notes.
- [ ] Include/exclude map.
- [ ] Include/exclude Spotify link/QR placeholder.
- [ ] Preview before export if practical.

### 16.3 Yearbook Template

Pages:

- [ ] Cover page.
- [ ] Year stats page.
- [ ] Map page.
- [ ] Timeline summary page.
- [ ] Event detail pages.
- [ ] Closing page.

Event page content:

- [ ] Title.
- [ ] Date.
- [ ] Venue/city.
- [ ] Category.
- [ ] Cover image/pass visual.
- [ ] Selected photos.
- [ ] Notes if included.
- [ ] Spotify link if included.

### 16.4 Ticket Wall Template

- [ ] Grid layout.
- [ ] Ticket-card styling.
- [ ] Year title.
- [ ] Category colors.
- [ ] Short venue/date labels.
- [ ] Works with 6, 12, 24, 48 events.

### 16.5 Print Quality Checks

- [ ] Test text readability at A4.
- [ ] Test text readability at Letter.
- [ ] Test image resolution.
- [ ] Test PDF file size.
- [ ] Test margins.
- [ ] Test long titles.
- [ ] Test missing photos.
- [ ] Open generated PDF in Files.
- [ ] AirDrop/open PDF outside app.
- [ ] Manually print one sample if possible.

Acceptance criteria:

- User can generate a PDF good enough to send to a printer manually.

---

## 17. Privacy and Security Todo

### 17.1 Copy and Expectations

- [ ] Write privacy copy for onboarding.
- [ ] Write import disclaimer.
- [ ] Write export disclaimer if exact location appears.
- [ ] Write Settings privacy explanation.
- [ ] Avoid “backup Wallet” language.
- [ ] Avoid “scan all Wallet passes” language.
- [ ] Use “import passes/files you choose” language.

### 17.2 Data Minimization

- [ ] Store only memory data user needs.
- [ ] Avoid raw barcode storage.
- [ ] Avoid pass auth token storage.
- [ ] Hash pass identifiers for duplicate detection.
- [ ] Keep media local in MVP.
- [ ] Avoid analytics until privacy review.

### 17.3 Permissions

- [ ] Photos permission only when adding media.
- [ ] Files access only through user-selected import/export.
- [ ] No current location permission for map display.
- [ ] No Spotify OAuth in MVP.
- [ ] No iCloud entitlement in local MVP.

### 17.4 Export Privacy

- [ ] Preview export before sharing if feasible.
- [ ] Let user remove exact location from export if map/location included.
- [ ] Let user exclude notes from PDF.
- [ ] Let user exclude Spotify link.
- [ ] Clearly show exports are local files shared by user action.

---

## 18. Settings Todo

MVP settings:

- [ ] App info.
- [ ] Privacy explanation.
- [ ] Exported files management if needed.
- [ ] Delete all local data debug option for TestFlight or development.
- [ ] App version/build number.

Post-MVP settings:

- [ ] iCloud sync status.
- [ ] Subscription management.
- [ ] Theme selection.
- [ ] Language override if needed.
- [ ] Public share management if share URLs are added later.

---

## 19. Monetization Prep Todo

MVP can ship without full monetization, but architecture should not block it.

### 19.1 Free vs Pro Boundaries

Potential Pro boundaries:

- [ ] Unlimited memories.
- [ ] Premium recap themes.
- [ ] Premium timeline themes.
- [ ] High-resolution export.
- [ ] Print-ready PDF export.
- [ ] Future CloudKit sync.

Tasks:

- [ ] Decide which features are free in TestFlight.
- [ ] Decide which features are future Pro.
- [ ] Avoid hard-coding paywall decisions into core components.
- [ ] Design feature entitlement layer later.

### 19.2 StoreKit Later

Post-MVP:

- [ ] Add StoreKit 2 products.
- [ ] Add subscription screen.
- [ ] Add restore purchases.
- [ ] Add transaction verification.
- [ ] Add entitlement state.
- [ ] Add paywall tests.

Do not block local MVP on monetization.

---

## 20. QA Checklist

### 20.1 Golden Path Tests

- [ ] Fresh install.
- [ ] Complete onboarding.
- [ ] Create manual concert memory.
- [ ] Add location.
- [ ] Add photo.
- [ ] Add note.
- [ ] Add Spotify playlist URL.
- [ ] View in timeline.
- [ ] View in map.
- [ ] Generate annual recap.
- [ ] Export recap image.
- [ ] Export annual PDF.
- [ ] Generate print-ready PDF.
- [ ] Share/save exported files.

### 20.2 Import Tests

- [ ] Import valid `.pkpass`.
- [ ] Import invalid file.
- [ ] Import duplicate pass.
- [ ] Import pass with missing date.
- [ ] Import pass with missing location.
- [ ] Import pass with non-English metadata.
- [ ] Cancel import picker.
- [ ] Edit imported draft before save.

### 20.3 Data Edge Cases

- [ ] Event without date.
- [ ] Event without location.
- [ ] Event without media.
- [ ] Event with video only.
- [ ] Event with long title.
- [ ] Event with long notes.
- [ ] Multiple events on same day.
- [ ] Multiple events at same venue.
- [ ] 100+ events in timeline.
- [ ] Many photos attached to one event.

### 20.4 UI Edge Cases

- [ ] Small iPhone screen.
- [ ] Large iPhone screen.
- [ ] iPad if supported.
- [ ] Light mode.
- [ ] Dark mode if supported.
- [ ] Larger text sizes.
- [ ] Long localized strings.
- [ ] No network.
- [ ] Low storage/error state.

### 20.5 Export Tests

- [ ] Event card image opens outside app.
- [ ] Recap image opens outside app.
- [ ] Annual recap PDF opens in Files.
- [ ] Print-ready PDF opens in Files.
- [ ] Export works with missing photos.
- [ ] Export works with missing map data.
- [ ] Export works with 1 event.
- [ ] Export works with many events.
- [ ] Export filenames are readable.

---

## 21. Test Data Todo

Create sample memories for development:

- [ ] Concert with pass image, photos, Spotify link.
- [ ] Music festival with multiple photos.
- [ ] Exhibition with notes.
- [ ] Travel memory with map location.
- [ ] Sports event with no photos.
- [ ] Event without location.
- [ ] Event without date.
- [ ] Event with long title.
- [ ] Event with long notes.
- [ ] Multiple events in same year.
- [ ] Multiple years of events.

Use sample data to test:

- [ ] Timeline grouping.
- [ ] Map pins.
- [ ] Recap stats.
- [ ] Export layouts.
- [ ] Empty/fallback visuals.

---

## 22. Build Order Checklist

Recommended implementation sequence:

### Step 1: Bootstrap

- [x] Create iOS app project.
- [x] Add app shell.
- [x] Add resource/localization structure.
- [x] Add sample data.

### Step 2: Models

- [x] Add SwiftData models.
- [x] Add enums/stable IDs.
- [x] Add sample fixtures.
- [ ] Add basic model tests.

### Step 3: Manual Creation

- [x] Add create form.
- [x] Add edit form.
- [x] Add delete behavior.
- [x] Persist memory.

### Step 4: Timeline

- [x] Query memories.
- [x] Group by year/month.
- [x] Build timeline cards.
- [x] Add empty states.

### Step 5: Detail

- [x] Build detail screen.
- [x] Add notes.
- [x] Add favorite.
- [x] Add edit/delete navigation.

### Step 6: Media

- [ ] Add media picker.
- [ ] Store selected media.
- [ ] Generate thumbnails.
- [ ] Render gallery.
- [ ] Set cover image.

### Step 7: Map

- [ ] Add location fields/search.
- [ ] Render map pins.
- [ ] Add filters.
- [ ] Add marker preview.

### Step 8: `.pkpass` Import

- [ ] Add file picker.
- [ ] Parse pass.
- [ ] Create editable draft.
- [ ] Save memory + pass snapshot.
- [ ] Handle errors/duplicates.

### Step 9: Spotify Link

- [ ] Add playlist URL field.
- [ ] Validate/normalize.
- [ ] Render playlist card.
- [ ] Open externally.

### Step 10: Recap

- [ ] Generate stats.
- [ ] Build recap view model.
- [ ] Build first template.
- [ ] Add year selection.
- [ ] Add recap preview.

### Step 11: Export Image

- [ ] Export event card image.
- [ ] Export recap image.
- [ ] Share/save exported images.

### Step 12: Export PDF

- [ ] Export annual recap PDF.
- [ ] Export print-ready PDF.
- [ ] Share/save PDFs.

### Step 13: Polish

- [ ] Polish visual design.
- [ ] Polish empty states.
- [ ] Polish error states.
- [ ] Test full golden path.
- [ ] Prepare TestFlight.

---

## 23. Dependencies and Blocking Relationships

### Must happen before Timeline is useful

- [ ] Project bootstrap
- [ ] Data models
- [ ] Sample data or manual creation

### Must happen before Map is useful

- [ ] Memory events with coordinates
- [ ] Location entry/search
- [ ] Map annotation model

### Must happen before Recap is useful

- [ ] Memories by year
- [ ] Timeline/data queries
- [ ] Media/cover images improve quality but are not strictly required

### Must happen before Print-ready PDF is useful

- [ ] Recap/data stats
- [ ] Event detail data
- [ ] Export renderer
- [ ] PDF service

### Must happen before TestFlight

- [ ] Golden path works
- [ ] Import errors are handled
- [ ] Privacy copy is clear
- [ ] Local data persists
- [ ] Export files open outside app

---

## 24. Post-MVP Backlog

Do not build these until MVP loop is validated.

### 24.1 Cloud Sync

- [ ] CloudKit private database.
- [ ] SwiftData CloudKit configuration.
- [ ] Media sync policy.
- [ ] Sync status UI.
- [ ] Conflict handling.
- [ ] Pro subscription gating.

### 24.2 Public Share Pages

- [ ] Backend decision.
- [ ] Publish/unpublish flow.
- [ ] Public recap URL.
- [ ] Privacy controls.
- [ ] City-level location masking.
- [ ] Delete shared page.

### 24.3 Physical Products

- [ ] Print vendor research.
- [ ] Product SKUs.
- [ ] Pricing model.
- [ ] Order flow.
- [ ] Payment strategy.
- [ ] Shipping address handling.
- [ ] Fulfillment status.
- [ ] Refund/support process.

### 24.4 Smarter Import

- [ ] QR/barcode scanning.
- [ ] Ticket screenshot OCR.
- [ ] Photo date/location suggestions.
- [ ] Calendar suggestions.
- [ ] User-selected accessible Wallet import if APIs allow.

### 24.5 Spotify OAuth

- [ ] OAuth with PKCE.
- [ ] Keychain token storage.
- [ ] Playlist picker.
- [ ] Minimal scopes.
- [ ] Token refresh.
- [ ] Disconnect Spotify.

---

## 25. MVP Definition of Done

The MVP is done when all of the following are true:

- [ ] App launches reliably.
- [ ] User can complete onboarding.
- [ ] User can create a memory manually.
- [ ] User can import a `.pkpass` file or get a clear error.
- [ ] User can edit imported/manual memory.
- [ ] User can attach photos/videos.
- [ ] User can add notes.
- [ ] User can add Spotify playlist URL.
- [ ] User can view memories in timeline.
- [ ] User can view located memories on map.
- [ ] User can generate annual recap.
- [ ] User can export event card image.
- [ ] User can export recap image.
- [ ] User can export annual recap PDF.
- [ ] User can export print-ready PDF.
- [ ] Exported files can be opened outside the app.
- [ ] App does not claim automatic Wallet-wide import.
- [ ] App does not require backend.
- [ ] App does not require account.
- [ ] App does not upload sensitive ticket credentials.
- [ ] App permission prompts are contextual.
- [ ] Golden path has been manually tested.
- [ ] Edge cases have been reviewed.
- [ ] TestFlight build is ready.

---

## 26. First Implementation Sprint Candidate

If implementation starts next, recommended first sprint scope:

### Sprint 1 Goal

Create a running local-first app shell where a manually created memory appears in a polished timeline and detail page.

### Sprint 1 Tasks

- [x] Bootstrap iOS project.
- [x] Add app navigation shell.
- [x] Add localization resource structure.
- [x] Add category enum/config.
- [x] Add `MemoryEvent` model.
- [x] Add sample data.
- [x] Build manual create form.
- [x] Persist memory locally.
- [x] Build timeline screen.
- [x] Build event card.
- [x] Build detail screen.
- [x] Add edit/delete.
- [x] Add basic empty state.

### Sprint 1 Acceptance Criteria

- [ ] App builds. Blocked: requires Xcode on macOS.
- [ ] App launches. Blocked: requires Xcode on macOS.
- [x] User can create one memory.
- [x] Created memory appears in timeline.
- [x] User can open detail.
- [x] User can edit/delete the memory.
- [x] No Wallet/pass/media/export work is required in Sprint 1.

---

## 27. Review Gates

Before starting implementation:

- [ ] Confirm MVP display language.
- [ ] Confirm minimum iOS version.
- [ ] Confirm whether iPad is supported in MVP.
- [ ] Confirm whether dark mode is required in MVP.
- [ ] Confirm first recap visual direction.
- [ ] Confirm whether print-ready PDF export is free or future Pro.

Before TestFlight:

- [ ] Review privacy copy.
- [ ] Review App Store positioning language.
- [ ] Review all permission prompts.
- [ ] Review export behavior.
- [ ] Review pass import sensitive data handling.
- [ ] Test on physical device.

---

## 28. App Store Positioning Checklist

Use language like:

- [ ] “Turn your event tickets into a personal timeline.”
- [ ] “Import passes and ticket files you choose.”
- [ ] “Create beautiful annual recaps.”
- [ ] “Export shareable images and PDFs.”
- [ ] “Make print-ready keepsake PDFs.”

Avoid language like:

- [ ] “Automatically reads all Wallet tickets.”
- [ ] “Backs up your Wallet.”
- [ ] “Copies all Wallet passes.”
- [ ] “Stores your ticket credentials in the cloud.”
- [ ] “Publicly shares your event history automatically.”

---

## 29. Final Execution Principle

Build the smallest local-first version that proves emotional value:

1. Create/import memory.
2. Attach personal context.
3. See life timeline and map.
4. Generate beautiful recap.
5. Export image/PDF.
6. Produce print-ready PDF.

Everything else should wait until this loop is validated with real users.
