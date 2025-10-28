# swift-ui-debug-scan

[![CI](https://github.com/ConsultingMD/swift-ui-debug-scan/workflows/CI/badge.svg)](https://github.com/ConsultingMD/swift-ui-debug-scan/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/ConsultingMD/swift-ui-debug-scan)](https://github.com/ConsultingMD/swift-ui-debug-scan/releases)
[![codecov](https://codecov.io/gh/ConsultingMD/swift-ui-debug-scan/branch/main/graph/badge.svg)](https://codecov.io/gh/ConsultingMD/swift-ui-debug-scan)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-lightgrey.svg)](https://github.com/ConsultingMD/swift-ui-debug-scan)

**Enhanced SwiftUI debugging with structured view insights and render tracking.**

## Quick Start

```swift
import SwiftUI
import SwiftUIDebugScan

struct FeatureRootView: View {
    var body: some View {
        List {
            FeatureLeafView()
            FeatureLeafView()
            FeatureLeafView()
        }
        .debugScan("FeatureRootView")
    }
}
```

**Console Output:**
```
🧩 [FeatureRootView]
    • 📂 file: FeatureRootView.swift
    • 📚 module: Feature
    • 🎨 redraws: 1
    • ⏱️ timestamp: 2025-07-21 14:05:40 +0000
```

## Why Use This?

- **View Metadata**: Track file, module, and render counts
- **Debug Complex UIs**: Essential for large, server-driven applications  
- **Performance Insights**: Identify over-rendering and optimization opportunities
- **Targeted Debugging**: Focus on root views without log noise


## Usage Best Practices

**✅ Apply to root views:**
```swift
NavigationView {
    HomeScreen()
}.debugScan("HomeNavigation")
```

**❌ Avoid on leaf views:**
```swift
// Don't do this - too much noise
Text("Button").debugScan("ButtonText")
```

** Recommended targets:**
- Screen root views
- Major container views  
- Complex custom components
- Views with performance concerns

## Advanced Features

### Verbose Mode
Set `SWIFTUI_DEBUG_SCAN_VERBOSE=1` for detailed diagnostics:
- 🧵 Call stack and thread info
- 💾 Memory and CPU usage  
- ⏱️ Performance timing
- 📊 System metrics

## Installation

### Option 1: Swift Package Manager (Recommended)
```swift
dependencies: [
    .package(url: "https://github.com/ConsultingMD/swift-ui-debug-scan", from: "0.1.0")
]
```
**Xcode:** `File > Add Packages` → Enter URL above

### Option 2: Direct File Integration (Zero Dependencies)
1. Download [`DebugScan.swift`](Sources/SwiftUIDebugScan/DebugScan.swift)
2. Drag the file into your project
3. Skip the `import SwiftUIDebugScan` line - start using `.debugScan()` immediately

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Quick fixes:** Fork → Change → Test → PR  
**New features:** Open issue first to discuss
