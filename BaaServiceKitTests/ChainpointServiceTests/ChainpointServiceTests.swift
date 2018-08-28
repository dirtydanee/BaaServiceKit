import XCTest
@testable import BaaServiceKit

class ChainpointServiceTests: XCTestCase {

    var service: ChainpointService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        self.apiClient = MockAPIClient()
        self.service = ChainpointService(apiClient: self.apiClient)
    }
    
    override func tearDown() {
        self.apiClient = nil
        self.service = nil
        super.tearDown()
    }
    
    func testsAllSuccessProofs() throws {
        let file = Bundle(for: type(of: self)).url(forResource: "PartialFakeProofResponse", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let response = APIResponse(request: URLRequest.stub, result: json)
        self.apiClient.result = .success(response)
        let nodeHash = NodeHash.fake1
        let expectation = self.expectation(description: "Returning operation's result")
        self.service.proof(for: [nodeHash]) { results in
            XCTAssertEqual(results.count, 1)
            guard case let Result.success(proof) = results[0] else {
                XCTFail("Result should contain one success proof")
                return
            }
            XCTAssertEqual(proof.nodeHash, nodeHash)
            XCTAssertEqual(proof.status, .partial)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
    }

    func testsOneFailingProofs() throws {
        self.apiClient.result = .failure(MockingError.testingError)
        let nodeHash = NodeHash.fake1
        let expectation = self.expectation(description: "Returning operation's result")
        self.service.proof(for: [nodeHash]) { results in
            XCTAssertEqual(results.count, 1)
            guard case let Result.failure(error) = results[0] else {
                XCTFail("Result should contain one failure proof")
                return
            }

            XCTAssertTrue(error is MockingError)
            XCTAssertEqual(error as! MockingError, MockingError.testingError)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
    }
}

