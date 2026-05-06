# Task-Marking Audit — Last 7 Commits

Audited each commit for:
- **Over-marking**: every `[x]` task is actually implemented
- **Under-marking**: no `[ ]` task has actually been implemented already

Then re-verified all over-marked items against **latest HEAD** to filter out items since fixed.

---

## Re-verification Results (vs. latest HEAD)

### Now Implemented — Can Keep [x]

These were over-marked at commit time but have since been implemented:

| Item | Evidence |
|------|----------|
| Onboarding — "Explain user-selected import model" | `OnboardingView.swift` three-page flow with "You choose what to import" |
| Onboarding — "Avoid claiming automatic Wallet import" | Onboarding never mentions automatic Wallet import |
| Onboarding — No premature permissions (4 items: Photos, Location, Spotify, iCloud) | Onboarding requests zero permissions |
| Group by year/month (Step 4 summary) | `groupedByYearAndMonth` with `MonthGroup` in `TimelineView` |
| `.pkpass` import | `PassImportService.importPass` + `ImportPassView` file picker |
| Hash pass identifiers | `CryptoKit` `SHA256` hashing in `PassImportService` |
| Store pasted Spotify URL | `SpotifyLinkSection` has paste TextField + validation |

### Still Over-Marked — Should Be Reverted to [ ]

23 items remain genuinely over-marked in the current codebase:

| # | Item | Why still over-marked |
|---|------|----------------------|
| 1 | Deep links | No `onOpenURL`, URL scheme, or universal links |
| 2 | Button styles | No custom `ButtonStyle` definitions anywhere |
| 3 | Dynamic Type | Fixed `.system(size: 48/64/72)` on core screens |
| 4 | Tappable targets 44pt | No systematic enforcement |
| 5 | Theme resource structure | Only a `themeId` string, no theme files/enum |
| 6 | Generated artifact references | `ExportArtifact` never instantiated by any code |
| 7 | Info.plist usage strings | No Info.plist file exists |
| 8 | Video thumbnails | No `AVAssetImageGenerator`, image-only thumbnails |
| 9 | Video selection | Pipeline hardcodes `type: .image`, corrupts videos |
| 10 | Location confidence | Field exists but never set by UI or services |
| 11 | Location editing (coordinates) | Text fields only, no coordinate picker or geocoding |
| 12 | Location search | No `MKLocalSearch` or geocoding |
| 13 | Location prefilled from pass | `prefillFromResult` only sets title + date |
| 14 | Spotify link/QR in PDF | Renderer never renders Spotify content |
| 15 | Include/exclude photos in PDF | Toggle exists but renderer ignores it |
| 16 | Include/exclude map in PDF | Toggle exists but renderer ignores it |
| 17 | Include/exclude Spotify in PDF | Toggle is vacuous |
| 18 | Select year in PDF options | No year picker in options sheet |
| 19 | Write import disclaimer | No privacy/legal disclaimer in import flow |
| 20 | Let user exclude Spotify link | Toggle controls nothing |
| 21 | Avoid hard-coding paywall decisions | No monetization/feature-flag layer at all |
| 22 | Expired pass handling | No `expirationDate` check |
| 23 | Pass visuals fallback | No fallback when `pass.icon` is nil |

### Under-Marked — Should Be Marked [x]

1 item is implemented but still unchecked:

- **Export files open outside app** — `ShareSheet` wrapping `UIActivityViewController` is fully implemented but task remains `[ ]`

---

## Original Per-Commit Breakdown

### b2117ab — "bootstrap iOS app with models, timeline, create/edit/detail views"

**Over-marked (~20 items):** The most problematic commit. Key issues:
- **Deep links** — only in-app `NavigationLink`, no `onOpenURL`/URL scheme *(still over-marked)*
- ~~**Onboarding (6 items)** — no onboarding screen exists~~ *(now implemented)*
- **Button styles** — `DesignSystem.swift` has spacing/corners/shadow only *(still over-marked)*
- **Theme resource structure** — no theme files or config exist *(still over-marked)*
- ~~**`.pkpass` import** — not implemented~~ *(now implemented)*
- ~~**Hash pass identifiers** — fields named `*Hash` but no hashing code~~ *(now implemented)*
- ~~**Store pasted Spotify URL** — model field only, no paste UI~~ *(now implemented)*
- ~~**Group by year/month** — only year grouping~~ *(now implemented)*
- **Dynamic Type** — uses fixed `.system(size: 48/64)` *(still over-marked)*
- **Generated artifact references** — model relationship only *(still over-marked)*

**Under-marked:** None found.

---

### ee6f1da — "add map view, media gallery, Spotify link, and services"

**Over-marked (5 items) — all still over-marked:**
- **Video thumbnails** — no `AVAssetImageGenerator`; only a play icon overlay
- **Video selection** — `PhotosPicker` accepts videos but pipeline hardcodes `type: .image`
- **Store location confidence** — enum/field exist but never populated by any UI
- **Location editing** — text fields for venue/city only; no coordinate picker or geocoding
- **Location search (Step 7 summary)** — no `MKLocalSearch` or equivalent

**Under-marked:** None found.

---

### 815c942 — "add .pkpass import, recap stats, onboarding flow"

**Over-marked (3 items) — all still over-marked:**
- **Show location prefilled** — `prefillFromResult` only sets title + date, never location
- **Expired pass handling** — no check for `PKPass.expirationDate`
- **Pass whose visuals cannot be extracted** — no fallback if `pass.icon` is nil

**Under-marked:** None found.

---

### fa0868a — "add export system — event card images, recap images, and PDF generation"

**Over-marked (5 items) — all still over-marked:**
- **Spotify link/QR in PDF** — toggle exists but renderer never reads it or renders anything
- **Include/exclude photos in PDF** — toggle UI exists but renderer never checks `includePhotos`
- **Include/exclude map in PDF** — toggle UI exists but renderer never checks `includeMap`
- **Include/exclude Spotify in PDF** — toggle UI exists, no Spotify content rendered
- **Select year in PDF options** — year comes from RecapView picker, not the PDF options sheet itself

**Under-marked:** None found.

---

### 5a13b2f — "enhance settings with data management, mark privacy/security tasks"

**Over-marked (3 items still over-marked, 1 resolved):**
- **Write import disclaimer** — description text exists but no privacy/legal disclaimer *(still over-marked)*
- **Let user exclude Spotify link** — toggle exists but PDF never renders a Spotify link *(still over-marked)*
- **Avoid hard-coding paywall decisions** — no monetization code exists at all *(still over-marked)*
- ~~**Hash pass identifiers** (borderline)~~ *(now properly implemented with CryptoKit)*

**Under-marked:** None found.

---

### a4cdb08 — "add timeline month grouping and accessibility labels"

**Over-marked:** None found. All 3 tasks genuinely implemented.

**Under-marked:** None found.

---

### 06656e8 — "mark dependency, positioning, and satisfied tasks"

**Over-marked:** None found.

**Under-marked (1 item):**
- **Export files open outside app** — `ShareSheet` wrapping `UIActivityViewController` is fully implemented but task remains `[ ]`

---

## Summary

| Commit | Originally Over-marked | Still Over-marked | Under-marked |
|--------|----------------------|-------------------|--------------|
| b2117ab (bootstrap) | ~20 | **~10** | 0 |
| ee6f1da (map/media) | 5 | **5** | 0 |
| 815c942 (import/recap) | 3 | **3** | 0 |
| fa0868a (export) | 5 | **5** | 0 |
| 5a13b2f (settings) | 4 | **3** | 0 |
| a4cdb08 (timeline) | 0 | 0 | 0 |
| 06656e8 (marking) | 0 | 0 | **1** |
| **Total** | **~37** | **~26** | **1** |

~10 items have been resolved by later commits. **23 items remain genuinely over-marked** and should be reverted to `[ ]`. The dominant pattern is toggle-UI or model fields that exist without backing renderer/logic, and tasks marked done "by omission."
