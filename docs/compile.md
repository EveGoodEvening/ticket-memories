# How to Build & Run Ticket Memories

## Prerequisites

- **macOS** (required for Xcode)
- **Xcode** (latest stable recommended)
- An iOS Simulator or a physical iOS device

## Current State

The repository contains only Swift/SwiftUI source code under `TicketMemories/` and tests under `TicketMemoriesTests/`. There is currently **no `.xcodeproj`, `.xcworkspace`, or `Package.swift`** checked in, so you need to create one before building.

## Option A: Create an Xcode Project

1. Open Xcode and create a new **App** project (iOS, SwiftUI).
2. Drag the `TicketMemories/` folder into the project navigator.
3. Add `TicketMemoriesTests/` as a test target.
4. Build with **Cmd+R** to run on the simulator or a connected device.

## Option B: Create a Swift Package

1. Add a `Package.swift` at the repo root defining the app target and test target.
2. Build from the command line:
   ```bash
   xcodebuild -scheme TicketMemories -destination 'platform=iOS Simulator,name=iPhone 16'
   ```
   Or open `Package.swift` in Xcode and run from there.

## Run Target

- **iOS Simulator** (any recent iPhone model)
- **Physical device** (requires an Apple Developer account for signing)
