// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "swift-ui-debug-scan",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .visionOS(.v1),
        .watchOS(.v8),
    ],
    products: [
        .library(name: "SwiftUIDebugScan", targets: ["SwiftUIDebugScan"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIDebugScan",
            dependencies: [],
        ),
    ],
    swiftLanguageModes: [.v6]
)
