// swift-tools-version:4.0
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
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/Kitura/BlueSignals.git", .upToNextMajor(from: "1.0.200")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.4"))
    ],
    targets: [
        .target(
            name: "hola-server",
            dependencies: [
                "Swifter",
                "Signals",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "hola-serverTests",
            dependencies: ["hola-server"])
    ]
)
