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
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.4.7")
            .branch("stable")),
        .package(url: "https://github.com/IBM-Swift/BlueSignals.git", .upToNextMinor(from: "1.0.21"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: projectName,
            dependencies: ["Swifter", "Signals"]),
        .testTarget(
            name: "hola-serverTests",
            dependencies: [projectName]),
    ]
)
