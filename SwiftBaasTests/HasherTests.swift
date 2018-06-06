import XCTest
@testable import SwiftBaas

class HasherTests: XCTestCase {

    var hasher: Hasher!

    override func setUp() {
        super.setUp()
        self.hasher = Hasher()
    }

    override func tearDown() {
        self.hasher = nil
        super.tearDown()
    }

    func testDataHashing() {
        let data = "Hello World!".data(using: .utf8)
        let firstHash = hasher.sha256(from: data!)
        let secondHash = hasher.sha256(from: data!)
        XCTAssertEqual(firstHash, secondHash)
    }

    func testStringHashing() {
        let string = "Hello World!"
        let firstHash = hasher.sha256(from: string)
        let secondHash = hasher.sha256(from: string)
        XCTAssertEqual(firstHash, secondHash)
    }
}
