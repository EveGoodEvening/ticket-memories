# Ticket Memories 初始化规划

Date: 2026-05-06
Project: Ticket Memories / 票根回忆
Status: Initial product and technical plan

## 1. Product Summary

Ticket Memories 是一个 iOS app，用来把用户选择导入或手动创建的活动票根整理成一条可回顾、可分享、可打印的个人人生时间线。

核心定位：

> Wallet 是票据入口，Ticket Memories 是记忆层。

本产品不应该被定义为“Wallet pass maker”或“自动读取 Wallet 历史的工具”。Apple 可能在 iOS 27 中加入原生自定义 Wallet pass 创建能力，因此 Ticket Memories 的长期价值应集中在：

- 时间线回忆整理
- 地图足迹
- 活动照片/视频/笔记聚合
- Spotify 歌单关联
- 年度活动回顾
- 高质量图片/PDF 导出
- print-ready 纪念册 PDF
- 后续实体纪念品打印

## 2. Confirmed Product Decisions

本计划已根据以下决策更新：

1. **语言策略**
   - App 架构从第一天支持中英扩展。
   - MVP UI 可以先做单语言，中文或英文均可。
   - 文案、分类、主题名、导出模板应使用可本地化结构，而不是硬编码在业务逻辑中。

2. **内容范围**
   - MVP 不只聚焦演唱会。
   - 第一版需要覆盖：
     - 演唱会
     - 音乐节
     - 展览
     - 旅行
     - 体育赛事
   - 分类设计应允许后续加入剧场、电影节、会议、主题公园、其他活动等。

3. **MVP 优先级**
   - 优先做漂亮的 timeline 和 annual recap。
   - 导入用 `.pkpass` 和手动创建作为可靠兜底。
   - 不依赖“自动读取所有 Wallet pass”。

4. **分享策略**
   - MVP 只做图片/PDF 导出。
   - 不做公开 share URL。
   - 不做社交 feed。
   - 不做网页托管。

5. **实体纪念册策略**
   - 先做 print-ready PDF。
   - 暂不做完整实体订单、物流、客服和 print-on-demand 集成。

6. **Wallet 访问承诺**
   - 不承诺自动读取所有 Apple Wallet 门票。
   - 产品文案应明确为“导入你选择的票据/pass”。

## 3. Target Experience

用户打开 Ticket Memories 后，应该感觉它像一个“活动人生相册”，而不是一个工具型票夹。

理想用户流程：

1. 用户导入一张 `.pkpass` 或手动创建活动。
2. App 自动或半自动填充活动标题、日期、地点、分类。
3. 用户添加照片、视频、笔记和 Spotify 歌单。
4. 活动出现在时间线和地图上。
5. 用户年底生成年度活动回顾。
6. 用户导出漂亮的分享图片或 PDF。
7. 用户后续可以生成 print-ready 纪念册 PDF。

## 4. MVP Product Scope

### 4.1 In Scope

MVP 应包含以下功能。

#### 4.1.1 活动创建

入口：

- `.pkpass` 文件导入
- 手动创建

可后续加入但不是第一优先级：

- QR code / barcode 扫描
- 票据截图 OCR
- 照片/日历推荐
- 可访问 Wallet pass 的用户选择式导入

#### 4.1.2 活动详情页

每个活动记忆至少包含：

- 标题
- 分类
- 日期
- 场馆/地点
- 城市/国家
- 地图坐标
- pass 缩略图或票根视觉
- 照片
- 视频
- 笔记
- Spotify playlist 链接
- 标签
- 收藏状态

#### 4.1.3 Timeline 首页

首页优先做 timeline，不以地图为默认首页。

Timeline 要支持：

- 按年份分组
- 按月份分组
- 大卡片视觉
- 分类 icon / color
- 封面图
- 空状态引导
- 快速创建第一段回忆

#### 4.1.4 地图

地图展示用户所有带坐标的活动：

- event pins
- 按年份筛选
- 按分类筛选
- 点击 pin 展示活动卡片
- 从卡片进入详情页

MVP 不需要：

- 复杂热力图
- 路线动画
- 多人地图
- 公开地图分享页

#### 4.1.5 年度活动回顾

年度回顾是 MVP 的核心亮点。

首版 recap 应生成静态图片或 PDF，包含：

- 年份标题
- 活动总数
- 去过城市数
- 分类分布
- 最常去地点/城市
- 年度地图缩略图
- 精选活动卡片
- 精选照片 grid
- Spotify playlist link 展示
- 导出按钮

#### 4.1.6 图片/PDF 分享

MVP 分享只支持本地导出：

- 单个活动分享卡片图片
- 年度回顾长图
- 年度回顾 PDF
- print-ready PDF 初版

不做：

- 公开 URL
- 服务器托管
- 网页分享页
- 点赞/评论/关注

#### 4.1.7 Print-ready PDF

实体纪念册第一阶段只做 print-ready PDF。

用户可以选择：

- 年份
- 活动范围
- 主题
- 页面尺寸
- 是否包含照片
- 是否包含地图
- 是否包含笔记
- 是否包含 Spotify QR/link

输出：

- 本地 PDF 文件
- 系统 share sheet
- 可保存到 Files

## 5. Explicit Non-goals for MVP

MVP 不做以下内容：

- 自动读取所有 Apple Wallet pass
- 完整 Wallet 历史扫描
- 公开分享网页
- 用户账号系统
- 社交 feed
- 云端媒体托管
- 实体订单履约
- 物流/退货/客服系统
- 复杂 AI 视频 recap
- 跨平台 Android/Web app
- 多人协作相册
- 完整票务平台 API 集成

## 6. Recommended Technical Stack

### 6.1 iOS App

- Language: Swift
- UI: SwiftUI
- Data: SwiftData
- Sync later: CloudKit private database
- Map: MapKit for SwiftUI
- Media selection: PhotosUI / PhotosPicker
- Video preview: AVKit
- Pass handling: PassKit
- File import/export: SwiftUI `fileImporter`, `fileExporter`, UIDocumentPicker where needed
- Share: ShareLink / UIActivityViewController
- PDF generation: SwiftUI rendering + PDFKit/CoreGraphics
- In-app purchase later: StoreKit 2
- Secure tokens later: Keychain

### 6.2 Localization Architecture

Even if MVP UI is single-language, structure should support future localization:

- Use String Catalogs (`.xcstrings`) or `Localizable.strings` from the beginning.
- Store category IDs as stable enum-like keys, not localized display strings.
- Store theme IDs as stable keys.
- Render localized category names only at UI/export layer.
- Export templates should use localized strings.

Example stable categories:

- `concert`
- `musicFestival`
- `exhibition`
- `travel`
- `sports`
- `theater`
- `other`

### 6.3 Backend Strategy

MVP should be local-first.

Recommended sequence:

1. Local-only MVP
2. CloudKit private sync
3. Optional backend later for public share pages and print fulfillment

Do not build backend in MVP because current confirmed sharing requirement is image/PDF only.

## 7. Data Model Plan

### 7.1 MemoryEvent

Represents one activity memory.

Fields:

- `id`
- `title`
- `category`
- `startDate`
- `endDate`
- `timezoneIdentifier`
- `venueName`
- `address`
- `city`
- `country`
- `latitude`
- `longitude`
- `locationConfidence`
- `notes`
- `tags`
- `coverMediaId`
- `source`
- `isFavorite`
- `createdAt`
- `updatedAt`

Category values:

- concert
- musicFestival
- exhibition
- travel
- sports
- theater
- other

Source values:

- pkpassFile
- manual
- qrScan
- walletUserSelected
- screenshot

Location confidence values:

- exact
- inferred
- manual
- unknown

### 7.2 PassSnapshot

Represents a safe, non-sensitive snapshot of pass metadata.

Fields:

- `id`
- `eventId`
- `organizationName`
- `localizedName`
- `localizedDescription`
- `serialNumberHash`
- `passTypeIdentifierHash`
- `relevantDate`
- `passURL`
- `thumbnailImagePath`
- `foregroundColor`
- `backgroundColor`
- `labelColor`
- `barcodeStoredPolicy`
- `createdAt`

Security rules:

- Do not upload raw barcode payload by default.
- Do not upload pass authentication token.
- Do not claim this is a full backup of Wallet credentials.
- If raw `.pkpass` storage is added later, require clear user consent and local encryption review.

### 7.3 MediaAsset

Represents photos or videos attached to a memory.

Fields:

- `id`
- `eventId`
- `type`
- `localFilePath`
- `thumbnailPath`
- `originalFilename`
- `capturedAt`
- `latitude`
- `longitude`
- `duration`
- `width`
- `height`
- `createdAt`
- `updatedAt`

MVP behavior:

- User actively selects media.
- Copy selected files or generated derivatives into app sandbox.
- Generate thumbnails.
- Do not require full Photos access on first launch.

### 7.4 SpotifyPlaylistLink

Represents a playlist associated with an event.

Fields:

- `id`
- `eventId`
- `spotifyURI`
- `externalURL`
- `name`
- `ownerName`
- `imageURL`
- `trackCount`
- `linkedAt`

MVP behavior:

- Accept pasted Spotify playlist URL.
- Store link and optional metadata.
- Open in Spotify or browser.

Later behavior:

- Add Spotify OAuth with PKCE.
- Use minimal scopes.
- `playlist-read-private` only if reading private playlists.
- Do not add playback-control scopes unless the product explicitly needs playback control.

### 7.5 AnnualRecap

Represents a generated yearly recap.

Fields:

- `id`
- `year`
- `title`
- `themeId`
- `generatedAt`
- `coverImagePath`
- `shareImagePath`
- `pdfPath`
- `statsJSON`

Stats can include:

- total events
- total cities
- total countries
- category counts
- favorite venue
- favorite city
- first event
- last event
- map bounds

### 7.6 ExportArtifact

Represents an exported image or PDF.

Fields:

- `id`
- `type`
- `eventId`
- `recapId`
- `localFilePath`
- `format`
- `createdAt`

Types:

- eventCardImage
- annualRecapImage
- annualRecapPDF
- printReadyPDF

## 8. App Structure Plan

Initial project structure:

```text
TicketMemories/
  App/
    TicketMemoriesApp.swift
    AppRouter.swift
  Models/
    MemoryEvent.swift
    PassSnapshot.swift
    MediaAsset.swift
    SpotifyPlaylistLink.swift
    AnnualRecap.swift
    ExportArtifact.swift
  Features/
    Onboarding/
    Import/
    Timeline/
    Map/
    MemoryDetail/
    Recap/
    Export/
    Settings/
  Services/
    PassImportService.swift
    PassSnapshotService.swift
    GeocodingService.swift
    MediaStorageService.swift
    SpotifyLinkService.swift
    RecapGenerator.swift
    ExportRenderer.swift
    PDFExportService.swift
  Resources/
    Assets.xcassets
    Localizable.xcstrings
    Themes/
```

Keep the structure feature-oriented but avoid over-engineering. MVP should prioritize a polished loop over infrastructure complexity.

## 9. Feature Implementation Plan

### 9.1 Onboarding

Goal: explain the product and create the first memory quickly.

Screens:

1. Welcome
2. Privacy promise
3. Create/import first memory

Key messages:

- Your tickets become a life timeline.
- Import only the passes/files you choose.
- Memories stay private unless exported/shared.

Do not ask for Photos, Location, Spotify, or Cloud permissions during onboarding unless needed by the immediate action.

### 9.2 Import

MVP import methods:

1. `.pkpass` file import
2. Manual creation

`.pkpass` import behavior:

- Let user pick a file.
- Parse with PassKit where possible.
- Extract safe metadata.
- Infer date/title/location where possible.
- Show confirmation/edit screen before saving.

Manual creation behavior:

- Title required.
- Date recommended.
- Category required.
- Location optional but encouraged.

### 9.3 Timeline

Timeline is the main screen.

MVP requirements:

- Year sections
- Month sections
- Event cards
- Cover image fallback
- Category styling
- Empty state
- Add/import button

Visual priority:

- Large image-led cards
- Ticket-like details
- Elegant date typography
- Smooth year/month navigation

### 9.4 Memory Detail

Sections:

- Hero cover
- Ticket/pass snapshot
- Date and location
- Map preview
- Notes
- Media gallery
- Spotify playlist
- Export/share actions

Editing:

- Edit title/category/date/location
- Add/remove media
- Edit notes
- Add/remove Spotify playlist link
- Change cover image

### 9.5 Map

MVP requirements:

- Show events with coordinates
- Category-colored markers
- Year/category filters
- Tap marker to show event preview
- Enter detail from preview

Privacy note:

- Since MVP map is local-only, no public map privacy controls are required yet.
- If export includes maps, allow user to choose whether to include exact venue or city-level label.

### 9.6 Recap

Recap should feel like a flagship feature.

MVP themes:

1. Classic Timeline
2. Festival Poster
3. Map Diary

Recap outputs:

- Share image
- PDF

Stats:

- Number of events
- Cities visited
- Category distribution
- Favorite venue/city
- Selected highlight photos

### 9.7 Export and Share

MVP export types:

- Event card image
- Annual recap image
- Annual recap PDF
- Print-ready PDF

Share implementation:

- Use native share sheet.
- Let user save to Photos or Files.
- No server upload.
- No public URL.

### 9.8 Print-ready PDF

Initial PDF templates:

1. Yearbook
   - cover page
   - year stats
   - map page
   - one page per selected event

2. Ticket Wall
   - grid of events
   - ticket visual style
   - short notes

3. Travel/Event Diary
   - chronological layout
   - more space for photos and notes

PDF options:

- A4
- Letter
- Square booklet later
- Include/exclude notes
- Include/exclude maps
- Include/exclude Spotify QR/link

## 10. Monetization Plan

### 10.1 Free Tier

- Limited number of memories or exports
- Basic timeline
- Basic map
- Basic recap theme
- Standard-resolution export

### 10.2 Pro Tier

Potential Pro features:

- Unlimited memories
- Premium timeline themes
- Premium recap themes
- High-resolution export
- Print-ready PDF export
- Future CloudKit sync
- Future advanced photo suggestions

### 10.3 One-time Purchases

Possible one-time purchases:

- Theme packs
- Single annual PDF export
- Premium print template pack

### 10.4 Later Physical Monetization

Later physical products:

- Printed annual memory book
- Ticket wall poster
- City/event map poster
- Postcards
- Stickers
- Framed prints

Do not build physical order fulfillment until print-ready PDF demand is validated.

## 11. Privacy and Security Plan

### 11.1 Privacy Principles

- Local-first by default.
- User chooses what to import.
- User chooses what to export.
- Do not promise Wallet-wide import.
- Do not upload sensitive ticket credential data by default.
- Do not request broad permissions early.

### 11.2 Sensitive Data Handling

Potentially sensitive data:

- Ticket barcode payload
- Pass authentication token
- Exact event location history
- Photos/videos
- Spotify playlist preferences

Rules:

- Avoid storing raw barcode payload in MVP.
- Hash pass identifiers if needed for duplicate detection.
- Keep media local unless future sync is explicitly enabled.
- Make export preview explicit.
- If exact location appears in PDF, let user edit or remove it.

### 11.3 Permission Timing

Request permissions only when needed:

- Photos: when adding media
- Files: when importing/exporting files
- Location: only if using current location features later
- Spotify: only when connecting Spotify account later
- iCloud: only when enabling sync later

## 12. Development Roadmap

### Phase 0: Project Bootstrap and Technical Spikes

Duration: 1 week

Goals:

- Create iOS project.
- Verify SwiftData model setup.
- Verify `.pkpass` import.
- Verify MapKit markers.
- Verify media storage and thumbnail generation.
- Verify image/PDF rendering.

Deliverables:

- Running app shell
- Initial data models
- `.pkpass` import spike
- Timeline prototype
- Recap rendering prototype

### Phase 1: Local MVP

Duration: 3-4 weeks

Features:

- Onboarding
- Manual event creation
- `.pkpass` file import
- Timeline
- Event detail
- Add photos/videos
- Add notes
- Add Spotify link
- Map view
- Basic export image

Success criteria:

- User can create/import first memory in under 2 minutes.
- User can see memory in timeline and map.
- User can export a shareable card.

### Phase 2: Beautiful Recap and PDF MVP

Duration: 3-4 weeks

Features:

- Annual recap generation
- Recap themes
- Recap image export
- Annual recap PDF export
- Print-ready PDF initial template
- Polish timeline visuals
- Polish empty states

Success criteria:

- User can generate a visually compelling annual recap.
- User can export image/PDF without backend.
- Print-ready PDF is usable for manual printing.

### Phase 3: TestFlight and Monetization Prep

Duration: 3-4 weeks

Features:

- StoreKit 2 skeleton
- Pro theme gating
- Export quality gating
- Better import error handling
- Duplicate detection
- Test data reset/debug tools
- Privacy copy polish

Success criteria:

- TestFlight build ready.
- 50-100 real users can test.
- Import/manual creation flow is stable.
- Recap/export flow is reliable.

### Phase 4: Cloud Sync Later

Duration: 4-6 weeks

Features:

- CloudKit private database
- Sync status UI
- Conflict handling
- Media sync strategy
- Pro subscription integration

Only start this after local MVP validates retention and export usage.

### Phase 5: Public Share and Physical Products Later

Features:

- Optional backend
- Public share pages
- Publish/unpublish controls
- Print vendor integration
- Physical orders
- Fulfillment status

Do not start until image/PDF sharing and print-ready PDF demand are validated.

## 13. Quality and Testing Plan

### 13.1 Functional Tests

Test cases:

- Create manual event with all fields.
- Create manual event with missing optional fields.
- Import valid `.pkpass`.
- Import invalid file.
- Edit imported event.
- Add photos.
- Add videos.
- Remove media.
- Add Spotify playlist URL.
- Generate timeline.
- Generate map pins.
- Generate annual recap.
- Export image.
- Export PDF.
- Generate print-ready PDF.

### 13.2 Edge Cases

- Event without date.
- Event without location.
- Event with approximate location.
- Multiple events same day.
- Multiple events same venue.
- Duplicate `.pkpass` import.
- Large photo selection.
- Video-only event.
- Long notes.
- Non-English pass metadata.
- Timezone mismatch.
- Offline mode.

### 13.3 UI Testing Priorities

Because this is a visual product, UI quality matters as much as data correctness.

Manually test:

- First-run experience
- Empty states
- Timeline scroll performance
- Event detail layout with many photos
- Recap templates
- PDF readability
- Dark mode
- Dynamic Type basics

## 14. Product Metrics

MVP should track or manually measure:

- First memory creation rate
- `.pkpass` import success rate
- Manual creation completion rate
- Photo attachment rate
- Notes attachment rate
- Spotify link attachment rate
- Timeline revisit rate
- Recap generation rate
- Export rate
- Print-ready PDF generation rate
- Theme preference

No invasive analytics should be added without a privacy review.

## 15. Key Risks

### Risk 1: Wallet access is limited

Mitigation:

- Use `.pkpass` import and manual creation as primary MVP paths.
- Describe Wallet import carefully.
- Avoid promising automatic Wallet reading.

### Risk 2: Product scope becomes too broad

Mitigation:

- Cover five categories, but keep the same underlying memory model.
- Use category-specific visual styling, not category-specific business logic.
- Avoid building separate flows for every category in MVP.

### Risk 3: Users do not want to manually organize memories

Mitigation:

- Make first memory creation fast.
- Make the timeline immediately rewarding.
- Make recap visually impressive.
- Add photo/date/location suggestions later only if needed.

### Risk 4: PDF generation quality is hard

Mitigation:

- Start with limited templates.
- Use fixed page sizes.
- Avoid too many customization options early.
- Test printed output manually.

### Risk 5: Privacy concerns reduce trust

Mitigation:

- Local-first messaging.
- Explicit import/export previews.
- Minimal permissions.
- Avoid storing sensitive pass credentials.

## 16. Initial Build Order

Recommended first implementation order:

1. Create iOS app project.
2. Add SwiftData models.
3. Implement manual event creation.
4. Implement timeline list.
5. Implement event detail page.
6. Implement media attachment.
7. Implement map pins.
8. Implement `.pkpass` file import.
9. Implement Spotify URL attachment.
10. Implement annual recap stats.
11. Implement recap visual template.
12. Implement image export.
13. Implement PDF export.
14. Implement print-ready PDF template.
15. Polish visual design and empty states.
16. Prepare TestFlight build.

## 17. Current Repository State

At the time of this planning document, the repository is essentially empty and does not yet contain an iOS project. The next implementation step is to bootstrap the iOS app structure and begin with a local-first MVP.

## 18. Final Recommendation

Build the first version as a beautiful, local-first iOS memory app rather than a Wallet automation tool.

The MVP should prove this loop:

1. User creates/imports an event memory.
2. User adds photos, notes, and optional Spotify playlist.
3. App displays the memory in a polished timeline and map.
4. App generates a beautiful annual recap.
5. User exports image/PDF.
6. User can generate a print-ready PDF for physical keepsakes.

If this loop feels emotionally valuable, CloudKit sync, premium themes, public share pages, and physical products can be added later with much lower risk.
