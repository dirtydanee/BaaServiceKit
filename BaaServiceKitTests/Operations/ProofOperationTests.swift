//
//  ProofOperationTests.swift
//  BaaServiceKitTests
//
//  Created by Daniel Metzing on 26.08.18.
//  Copyright © 2018 DirtyLabs. All rights reserved.
//

import XCTest
@testable import BaaServiceKit

class ProofOperationTests: XCTestCase {

    func testSuccessOperation() throws {
        let file = Bundle(for: type(of: self)).url(forResource: "PartialFakeProofResponse", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let response = APIResponse(request: URLRequest.stub, result: json)
        let apiClient = MockAPIClient()
        apiClient.result = .success(response)
        let nodeHash = NodeHash.fake1
        let expectation = self.expectation(description: "Returning operation's result")
        let op = ProofOperation(nodeHash: nodeHash, url: URL.stub, apiClient: apiClient)
        let q = OperationQueue()
        q.addOperation(op)
        op.completionBlock = {
            XCTAssertNotNil(op.result)
            guard case let Result.success(proof) = op.result! else {
                XCTFail("Invalid result type")
                return
            }
            XCTAssertEqual(proof.nodeHash, nodeHash)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
    }

    func testFailingOperation() {
        let apiClient = MockAPIClient()
        apiClient.result = .failure(MockingError.testingError)
        let nodeHash = NodeHash.fake1
        let expectation = self.expectation(description: "Returning operation's result")
        let op = ProofOperation(nodeHash: nodeHash, url: URL.stub, apiClient: apiClient)
        let q = OperationQueue()
        q.addOperation(op)
        op.completionBlock = {
            XCTAssertNotNil(op.result)
            guard case let Result.failure(error) = op.result! else {
                XCTFail("Invalid result type")
                return
            }
            XCTAssertTrue(error is MockingError)
            XCTAssertEqual(error as! MockingError, MockingError.testingError)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
    }
}
