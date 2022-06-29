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

#if swift(>=5.6)
// Add the documentation compiler plugin if possible
package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
)
#endif
