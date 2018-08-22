import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(hola_serverTests.allTests),
    ]
}
#endif