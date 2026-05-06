# Security Audit Notes

## Current Dependency State

Based on the current repository contents, this project does not have third-party dependency manifests or lockfiles. I did not find `Package.swift`, `Package.resolved`, `Podfile`, `Podfile.lock`, `Cartfile`, `Cartfile.resolved`, npm/pip/go/cargo dependency files, CI workflow files, or Xcode package references.

That means the current repository has very little exposure to dependency-based supply chain attacks. There is no evidence that opening or building the project would currently pull a third-party package into the build.

This does not mean supply chain risk is zero. The remaining relevant surfaces are Xcode itself, Apple SDKs, future Xcode project configuration, future CI configuration, build scripts, and any dependencies added later.

## What Xcode Will Do

Opening the project in Xcode should not create third-party dependencies by itself.

Xcode generally resolves and downloads Swift Package Manager dependencies only when:

- A package dependency has been explicitly added through Xcode, such as `File > Add Package Dependency`.
- The `.xcodeproj` or `.xcworkspace` already contains package references.
- A `Package.swift` based project is opened.

If a Swift package dependency is added later, Xcode will normally create or update `Package.resolved` to pin exact resolved versions and checksums for binary targets. That file should be committed for applications.

## Supply Chain Findings

No obvious dependency-based supply chain attack was found in the current repository.

I also did not find:

- Third-party package references.
- CI scripts that download or execute remote code.
- Non-sample Git hooks.
- Shell execution from the app source.
- Dynamic loading such as `dlopen` or `dlsym`.
- Obfuscated base64 or long hex payloads.
- Hardcoded secrets, API tokens, or private keys.
- Suspicious external domains.

The app code appears to rely on Apple frameworks such as SwiftUI, SwiftData, MapKit, PassKit, PDFKit, PhotosUI, CryptoKit, AVFoundation, and UIKit.

## Recommended Controls

1. Commit dependency lockfiles.

   The current `.gitignore` ignores `Package.resolved`. If this project later adds Swift Package Manager dependencies, remove that ignore rule and commit `Package.resolved`.

2. Review every dependency change.

   Treat changes to these files as high-signal security events:

   - `Package.swift`
   - `Package.resolved`
   - `*.xcodeproj/project.pbxproj`
   - `Podfile`
   - `Podfile.lock`
   - `Cartfile`
   - `Cartfile.resolved`
   - CI workflow files
   - Any build or run scripts

3. Prefer Apple system frameworks.

   For this project, many required capabilities are already covered by Apple SDKs. Avoid adding third-party packages for small utilities that can be implemented safely with the standard platform.

4. Avoid floating dependency refs.

   Prefer tagged releases or exact versions over branch-based dependencies. Avoid dependencies that track `main`, `master`, or arbitrary revisions unless there is a strong reason and review discipline.

5. Be careful with Swift package plugins.

   Swift package plugins can create build commands and may execute code during the build process. Review any dependency that declares plugin targets.

6. Be careful with binary targets.

   Binary dependencies are harder to inspect than source packages. If a package uses `binaryTarget`, verify the source, checksum, publisher, release history, and whether the binary is actually necessary.

7. Audit package manifests before adding dependencies.

   For Swift packages, inspect `Package.swift` for:

   - `binaryTarget`
   - `plugin`
   - `unsafeFlags`
   - executable targets
   - unusual repository URLs
   - scripts or generated code paths

8. Pin CI builds to resolved dependencies.

   Once the project has Swift package dependencies, CI should use the checked-in resolved file and avoid automatic dependency drift. For Xcode builds, use:

   ```bash
   xcodebuild ... -disableAutomaticPackageResolution
   ```

9. Keep build scripts minimal.

   Avoid Xcode Run Script phases unless they are necessary. If one is added, review it for network calls, shell downloads, credential access, and file writes outside the expected build directory.

10. Re-audit after adding an Xcode project or dependency.

    This repository currently has no `.xcodeproj` checked in. Once one is added, review `project.pbxproj` for package references, build phases, scripts, signing settings, and generated files.

## Bottom Line

At the moment, this repository does not appear to have third-party dependencies, so the dependency-based supply chain attack surface is very small.

If dependencies are added later, the main safeguards are: commit `Package.resolved`, avoid floating versions, review package manifests, avoid unnecessary binary targets and plugins, and prevent CI from automatically resolving to newer dependency versions.
