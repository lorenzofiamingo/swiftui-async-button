// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swiftui-async-button",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "AsyncButton",
            targets: ["AsyncButton"]),
    ],
    targets: [
        .target(
            name: "AsyncButton",
            dependencies: [],
            path: "Sources")
    ]
)
