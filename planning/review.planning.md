# Task-Marking Audit — Last 7 Commits

Audited each commit for:
- **Over-marking**: every `[x]` task is actually implemented
- **Under-marking**: no `[ ]` task has actually been implemented already

---

## b2117ab — "bootstrap iOS app with models, timeline, create/edit/detail views"

**Over-marked (~20 items):** The most problematic commit. Key issues:
- **Deep links** — only in-app `NavigationLink`, no `onOpenURL`/URL scheme
- **Onboarding (6 items)** — no onboarding screen exists; tasks marked done by omission
- **Button styles** — `DesignSystem.swift` has spacing/corners/shadow only, no button styles
- **Theme resource structure** — no theme files or config exist
- **`.pkpass` import** — not implemented (task itself says "later in import milestone")
- **Hash pass identifiers** — fields named `*Hash` but no `CryptoKit` / hashing code
- **Store pasted Spotify URL** — model field only, no paste UI
- **Group by year/month (Step 4 summary)** — only year grouping, no month grouping
- **Dynamic Type** — uses fixed `.system(size: 48/64)` that won't scale
- **Generated artifact references** — model relationship only, no generation code

**Under-marked:** None found.

---

## ee6f1da — "add map view, media gallery, Spotify link, and services"

**Over-marked (5 items):**
- **Video thumbnails** — no `AVAssetImageGenerator`; only a play icon overlay
- **Video selection** — `PhotosPicker` accepts videos but pipeline hardcodes `type: .image`
- **Store location confidence** — enum/field exist but never populated by any UI
- **Location editing** — text fields for venue/city only; no coordinate picker or geocoding
- **Location search (Step 7 summary)** — no `MKLocalSearch` or equivalent

**Under-marked:** None found.

---

## 815c942 — "add .pkpass import, recap stats, onboarding flow"

**Over-marked (3 items):**
- **Show location prefilled** — `prefillFromResult` only sets title + date, never location
- **Expired pass handling** — no check for `PKPass.expirationDate`
- **Pass whose visuals cannot be extracted** — no fallback if `pass.icon` is nil

**Under-marked:** None found.

---

## fa0868a — "add export system — event card images, recap images, and PDF generation"

**Over-marked (5 items):**
- **Spotify link/QR in PDF** — toggle exists but renderer never reads it or renders anything
- **Include/exclude photos in PDF** — toggle UI exists but renderer never checks `includePhotos`
- **Include/exclude map in PDF** — toggle UI exists but renderer never checks `includeMap`
- **Include/exclude Spotify in PDF** — toggle UI exists, no Spotify content rendered
- **Select year in PDF options** — year comes from RecapView picker, not the PDF options sheet itself

**Under-marked:** None found.

---

## 5a13b2f — "enhance settings with data management, mark privacy/security tasks"

**Over-marked (4 items):**
- **Write import disclaimer** — description text exists but no privacy/legal disclaimer
- **Let user exclude Spotify link** — toggle exists but PDF never renders a Spotify link anyway (vacuously true)
- **Avoid hard-coding paywall decisions** — no monetization code exists at all; marked done by omission
- **Hash pass identifiers** (borderline) — hashes already-hashed values redundantly

**Under-marked:** None found.

---

## a4cdb08 — "add timeline month grouping and accessibility labels"

**Over-marked:** None found. All 3 tasks marked done are genuinely implemented.

**Under-marked:** None found.

---

## 06656e8 — "mark dependency, positioning, and satisfied tasks"

**Over-marked:** None found.

**Under-marked (1 item):**
- **Export files open outside app** — `ShareSheet` wrapping `UIActivityViewController` is fully implemented but task remains `[ ]`

---

## Summary

| Commit | Over-marked | Under-marked |
|--------|------------|--------------|
| b2117ab (bootstrap) | **~20** | 0 |
| ee6f1da (map/media) | **5** | 0 |
| 815c942 (import/recap) | **3** | 0 |
| fa0868a (export) | **5** | 0 |
| 5a13b2f (settings) | **4** | 0 |
| a4cdb08 (timeline) | 0 | 0 |
| 06656e8 (marking) | 0 | **1** |

The dominant pattern is **over-marking** — tasks marked `[x]` where only the model/schema exists but no functional UI or logic backs it, or tasks satisfied "by omission" (nothing was built, so the constraint is trivially met). The bootstrap commit (b2117ab) is the worst offender with ~20 over-marked items. Under-marking is minimal (1 item total).
