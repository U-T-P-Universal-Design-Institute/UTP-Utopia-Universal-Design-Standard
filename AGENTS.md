# CursorMobile

A native SwiftUI iOS app (Xcode project) that drives the Cursor Cloud Agents API. See `README.md` for the product overview, API endpoints, and project structure.

## Cursor Cloud specific instructions

### Platform reality (read first)

This is an **iOS app built with Xcode**. The real build/run/test path is macOS-only:

- Build & run: open `CursorMobile/CursorMobile.xcodeproj` in Xcode 15+, then `⌘R` on an iOS 17+ simulator/device (per `README.md`).
- The app imports `SwiftUI`, `UIKit`, and `Security` (Keychain). **None of these Apple frameworks exist on Linux**, so the full app, all `Views/*`, `Services/KeychainService.swift`, `Services/CursorAPIService.swift`, and `Services/SSEClient.swift` **cannot be compiled or run on the Linux cloud VM**.
- There is no `Package.swift`, no XCTest target, no SwiftLint config, and no CI — so there is no automated test/lint suite to run here.

### What works on this Linux VM

The open-source Swift toolchain (Swift 6.3.2) is installed in the VM snapshot at `/opt/swift`, with `swift`/`swiftc` symlinked into `/usr/local/bin` (already on `PATH`). It ships swift-corelibs `Foundation` only — **no SwiftUI/UIKit/Security**.

The platform-independent core (`CursorMobile/CursorMobile/Models/*.swift` — Foundation-only data models, `Codable` types, status enums, computed display helpers) compiles and runs on Linux. To verify the data layer:

```bash
cd /tmp && rm -rf swiftcore && mkdir swiftcore && cd swiftcore
SRC=/workspace/CursorMobile/CursorMobile/Models
# add a main.swift that decodes Cursor API JSON into these models, then:
swiftc -o coredemo "$SRC/Agent.swift" "$SRC/Run.swift" "$SRC/Repository.swift" "$SRC/ChatMessage.swift" main.swift
./coredemo
```

This is the only end-to-end execution possible without macOS. Use it to sanity-check model decoding/encoding and Codable changes. Do **not** add `Views/*` or `Services/*` files to a Linux `swiftc` invocation — they pull in unavailable frameworks and will fail with `no such module 'SwiftUI'` / `'Security'`.

### Notes

- For real UI work, app testing, or anything touching `Views/`, `KeychainService`, networking, or the simulator, you need a macOS host with Xcode. Linux can only typecheck/run the Foundation-only model layer.
- Swift is preinstalled in the snapshot; the startup update script only re-asserts the `/usr/local/bin` symlinks (idempotent) and does not download anything.
