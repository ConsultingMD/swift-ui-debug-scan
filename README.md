# swift-ui-debug-scan

[![CI](https://github.com/ConsultingMD/swift-ui-debug-scan/workflows/CI/badge.svg)](https://github.com/ConsultingMD/swift-ui-debug-scan/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/ConsultingMD/swift-ui-debug-scan)](https://github.com/ConsultingMD/swift-ui-debug-scan/releases)
[![codecov](https://codecov.io/gh/ConsultingMD/swift-ui-debug-scan/branch/main/graph/badge.svg)](https://codecov.io/gh/ConsultingMD/swift-ui-debug-scan)
[![Documentation](https://img.shields.io/badge/docs-available-brightgreen)](https://consultingmd.github.io/swift-ui-debug-scan/)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-lightgrey.svg)](https://github.com/ConsultingMD/swift-ui-debug-scan)

A Swift package designed to enhance your debugging experience with SwiftUI views by providing detailed and structured debug logging.


## Why use swift-ui-debug-scan?

Debugging SwiftUI can often feel like navigating a maze, especially when trying to trace metadata such as the file a view belongs to, the module it was declared in, or how often it gets redrawn. This lack of visibility can be particularly challenging in large, server-driven UI applications where static data is sparse, and the codebase is unfamiliar.

swift-ui-debug-scan bridges this gap by offering structured, actionable insights into your SwiftUI views. With this tool, you can easily track view metadata, redraw counts, and other runtime information, making it easier to debug and optimize your SwiftUI applications.


## How it Works

The `.debugScan(_ label: String)` view modifier is the core of this library. By applying this modifier to your SwiftUI views, you can log structured debug information about the view's lifecycle and runtime behavior.

```swift
import SwiftUI
import SwiftUIDebugScan

struct ContentView: View {
    var body: some View {
        Text("Some feature").debugScan("Content")
    }
}
```

## Sample Debug Output

When running your app in debug mode, you'll see logs like the following in the console:

```
🧩 [Content]
    • 📂 file: ContentView.swift
    • 📚 module: MyApp
    • 🎨 redraws: 1
    • ⏱️ timestamp: 2025-07-21 14:05:40 +0000
```

## When to use `.debugScan`?

Apply the `.debugScan(_ label: String)` modifier to root views rather than leaf views. This ensures you capture meaningful data about the overall structure and behavior of your app without overwhelming your logs with excessive detail.

For example:

- Use `.debugScan(_ label: String)` on the root view of a screen or a major container view.
- Avoid applying it to small, frequently updated views unless necessary.

## Verbose Mode

For even more detailed logging, enable verbose mode by setting the `SWIFTUI_DEBUG_SCAN_VERBOSE` environment variable to true, yes, or 1. This will include additional runtime information such as:

- Call stack symbols
- Thread details
- System memory and processor usage
- Uptime and elapsed time

Verbose mode is especially useful for diagnosing complex issues in large applications.

## Installation

Add this package to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/ConsultingMD/swift-ui-debug-scan", from: "0.1.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "SwiftUIDebugScan", package: "swift-ui-debug-scan")
    ]
)
```

Alternatively, you can add the package directly in Xcode:

1. Open your project in Xcode.
2. Navigate to `File > Add Packages`.
3. Enter the repository URL: `https://github.com/ConsultingMD/swift-ui-debug-scan`.
4. Choose the version or branch you want to use.
5. Add the package to your desired target.

## Contributing

Contributions are welcome! If you have ideas for new features, improvements, or bug fixes, feel free to open an issue or submit a pull request.
