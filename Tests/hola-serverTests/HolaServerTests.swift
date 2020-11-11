import XCTest
import class Foundation.Bundle

final class HolaServerTests: XCTestCase {

    func testLaunch() throws {
        // Test that the tool can be launched with default arguments

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let server = productsDirectory.appendingPathComponent("hola-server")

        let process = Process()
        process.executableURL = server

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.interrupt()
        process.waitUntilExit()

        let status = process.terminationStatus

        XCTAssertEqual(status, 2)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testLaunch", testLaunch),
    ]
}
