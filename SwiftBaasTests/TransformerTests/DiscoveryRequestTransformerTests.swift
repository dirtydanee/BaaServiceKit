import XCTest
@testable import SwiftBaas

class DiscoveryRequestTransformerTests: XCTestCase {

    var transformer: DiscoveryRequestTransformer!

    override func setUp() {
        super.setUp()
        self.transformer = DiscoveryRequestTransformer()
    }
    
    override func tearDown() {
        self.transformer = nil
        super.tearDown()
    }

    func testTransformation() {
        let payload = [["public_uri": "https://127.0.0.1"]]
        let result = self.transformer.transform(payload)
        if case let .success(nodeURIs) = result {
            XCTAssertEqual(nodeURIs.count, 1)
            XCTAssertEqual(nodeURIs.first!.absoluteString, "https://127.0.0.1")
        } else {
            XCTFail("Transformation should succeed")
        }

    }
}
