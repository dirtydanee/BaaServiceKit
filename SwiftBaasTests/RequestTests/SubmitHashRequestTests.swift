import XCTest
import Alamofire
@testable import SwiftBaas

class SubmitHashRequestTests: XCTestCase {
    
    func testSubmitHashRequest() {
        let url = URL(string: "https://127.0.0.1")!
        let hashes = ["1", "2"]
        let request = SubmitHashRequest(url: url, hashes: hashes)
        XCTAssertEqual(request.httpMethod, .post)
        XCTAssertEqual(request.url, url.appendingPathComponent("hashes"))
        XCTAssertEqual(request.parameters as! [String: [String]], ["hashes": ["1", "2"]])
        XCTAssertTrue(request.encoding is JSONEncoding)
    }
}
