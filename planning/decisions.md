# Ticket Memories — M0 Product & Design Decisions

Date: 2026-05-06

## Language and Localization

- **MVP display language**: English. The architecture supports localization from day one via String Catalogs, but the first UI ships in English.
- All category IDs are stable enum keys (e.g. `concert`, `musicFestival`) independent of UI language.
- All theme IDs are stable keys independent of UI language.
- Localization resource structure is added from project bootstrap (`.xcstrings` or `Localizable.strings`).
- Exported recap/PDF strings come from localization resources.
- No localized strings are stored as persistent enum raw values.
- Changing UI language later does not require data migration.

## Category Scope

MVP categories with stable IDs:

| ID              | Display Name (EN) | Display Name (ZH) | Icon (SF Symbol)         | Color (Hex)  |
|-----------------|--------------------|--------------------|--------------------------|--------------|
| `concert`       | Concert            | 演唱会              | `music.mic`              | `#FF6B6B`    |
| `musicFestival` | Music Festival     | 音乐节              | `music.note.list`        | `#FF9F43`    |
| `exhibition`    | Exhibition         | 展览                | `paintpalette`           | `#54A0FF`    |
| `travel`        | Travel             | 旅行                | `airplane`               | `#5F27CD`    |
| `sports`        | Sports             | 体育赛事            | `sportscourt`            | `#10AC84`    |
| `theater`       | Theater            | 剧场                | `theatermasks`           | `#EE5A24`    |
| `other`         | Other              | 其他                | `ticket`                 | `#636E72`    |

- All categories share the same `MemoryEvent` model.
- No category-specific data models in MVP.
- Adding a new category requires only adding an enum case, config entry, localized strings, and optional assets.
- Fallback cover treatment: gradient background using category color with centered category icon.

## MVP Non-goals (Guardrails)

Confirmed non-goals:
- No automatic Wallet-wide pass scanning
- No public share URL
- No backend dependency
- No user account requirement
- No social graph
- No physical print order checkout
- No CloudKit sync in MVP
- No Spotify OAuth in MVP (pasted URL only)
- No raw barcode upload

## App Navigation

- **Structure**: TabView with four tabs
- **Default landing**: Timeline
- **Tabs**: Timeline, Map, Recap, Settings
- Primary create/import action accessible from Timeline via floating button
- Deep links can open specific memory detail

## Onboarding

- Welcome headline: "Your Events, Your Story"
- Value proposition: "Turn your tickets into a personal timeline of memories."
- Privacy promise: "Your memories stay on your device. You choose what to import and share."
- Import model: User-selected import only
- CTAs: "Create Memory" and "Import .pkpass"
- No permissions requested during onboarding

## Visual Design Direction

- **Target feeling**: Emotional, premium, personal, memory-book-like
- **Typography**: Rounded sans-serif for titles (SF Rounded), standard SF Pro for body
- **Ticket-card language**: Rounded corners, subtle shadow, pass-like proportions
- **Color system**: Each category has a primary color (see table above)
- **Timeline spacing**: Generous vertical spacing, large image-led cards
- **Dark mode**: Support dark mode from MVP (SwiftUI makes this straightforward)
- **Fallback visuals**: Category-colored gradient with icon when no photos/pass images exist

## Design System Basics

- **Spacing scale**: 4, 8, 12, 16, 24, 32, 48, 64
- **Corner radius scale**: 8 (small), 12 (medium), 16 (large), 24 (card)
- **Shadow**: Subtle drop shadow (color: black 8%, y: 2, blur: 8)
- **Button styles**: Primary (filled, rounded), Secondary (outlined), Destructive (red)
- **Card styles**: Rounded corners (16pt), subtle shadow, optional category accent

## Accessibility

- Dynamic Type supported for core screens
- Tappable targets minimum 44pt
- Timeline cards and map markers have accessible labels
- Text contrast meets WCAG AA

## Platform

- **Minimum iOS version**: 17.0 (for SwiftData, modern MapKit)
- **Swift version**: 5.9+
- **iPad**: Not required in MVP, but layout should not break on iPad
- **Dark mode**: Supported from MVP
