// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIDebugScan",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .define("BUILD_LIBRARY_FOR_DISTRIBUTION", .when(configuration: .release)),
            ]
        ),
        .testTarget(
            name: "SwiftUIDebugScanTests",
            dependencies: [
                "SwiftUIDebugScan",
                .product(name: "ViewInspector", package: "ViewInspector")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
