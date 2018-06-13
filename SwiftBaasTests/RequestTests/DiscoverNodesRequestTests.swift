import XCTest
import Alamofire
@testable import SwiftBaas

class DiscoverNodesRequestTests: XCTestCase {

    func testDiscoverNodesRequest() {
        let url = URL(string: "https://127.0.0.1")!
        let request = DiscoverNodesRequest(discoveryURL: url)
        XCTAssertEqual(request.httpMethod, .get)
        XCTAssertEqual(request.url, url)
        XCTAssertNil(request.parameters)
        XCTAssertTrue(request.encoding is URLEncoding)
    }
}
