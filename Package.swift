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
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/httpswift/swifter.git", .branch("stable")),
        .package(url: "https://github.com/IBM-Swift/BlueSignals.git", .upToNextMinor(from: "1.0.6"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "hola-server",
            dependencies: ["Swifter", "Signals"]),
        .testTarget(
            name: "hola-serverTests",
            dependencies: ["hola-server"]),
    ]
)
