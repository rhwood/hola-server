// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let projectName = "hola-server"

let package = Package(
    name: projectName,
    products: [
        .executable(
            name: projectName,
            targets: [projectName])
    ],
    dependencies: [
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/IBM-Swift/BlueSignals.git", .upToNextMajor(from: "1.0.200")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.3.1"))
    ],
    targets: [
        .target(
            name: projectName,
            dependencies: [
                "Swifter",
                "Signals",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "hola-serverTests",
            dependencies: [projectName])
    ]
)
