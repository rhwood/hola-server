// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hola-server",
    products: [
        .executable(
            name: "hola-server",
            targets: ["hola-server"])
    ],
    dependencies: [
        .package(name: "Swifter", url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "1.0.0-alpha"),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.0.2"))
    ],
    targets: [
        .target(
            name: "hola-server",
            dependencies: [
                "Swifter",
                .product(name: "Lifecycle", package: "swift-service-lifecycle"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "hola-serverTests",
            dependencies: ["hola-server"])
    ]
)
