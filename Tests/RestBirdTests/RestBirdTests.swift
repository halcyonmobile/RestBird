import XCTest
@testable import RestBird

final class RestBirdTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RestBird().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
