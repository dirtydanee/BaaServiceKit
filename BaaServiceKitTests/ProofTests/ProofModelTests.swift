//
//  ProofModelTests.swift
//  BaaServiceKitTests
//
//  Created by David Szurma on 2018. 07. 12..
//  Copyright © 2018. DirtyLabs. All rights reserved.
//

import XCTest
@testable import BaaServiceKit

class ProofModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProofResponse() throws {
        let file = Bundle(for: type(of: self)).url(forResource: "PartialFakeProofResponse", withExtension: "json")!
        
        do {
        let data = try Data(contentsOf: file)
        let proofResponse = try ChainpointProofResponse.jsonDecoder.decode([ChainpointProofResponse].self, from: data)
        
        // Proof reponse root object tests
        XCTAssertEqual(proofResponse.count, 1)
        XCTAssertEqual(proofResponse.first!.hashIdNode, "a4b52f60-7322-11e8-876e-0159403461ed")
        XCTAssertEqual(proofResponse.first!.anchorsComplete!.count, 1)
        XCTAssertEqual(proofResponse.first!.anchorsComplete!.first!, "cal")
        
        // Proof response proof tests
        XCTAssertEqual(proofResponse.first!.proof!.context, URL(string: "https://w3id.org/chainpoint/v3"))
        XCTAssertEqual(proofResponse.first!.proof!.type, "Chainpoint")
        XCTAssertEqual(proofResponse.first!.proof!.hash, "1957db7fe23e4be1740ddeb941ddda7ae0a6b782e636a9e00b5aa82db1e84547")
        XCTAssertEqual(proofResponse.first!.proof!.hashIdNode, "a4b52f60-7322-11e8-876e-0159403461ed")
        XCTAssertEqual(proofResponse.first!.proof!.hashSubmittedNodeAt, "2018-06-18T18:08:46Z")
        XCTAssertEqual(proofResponse.first!.proof!.hashIdCore, "a73c4f70-7322-11e8-b7ce-019b42e3a86a")
        XCTAssertEqual(proofResponse.first!.proof!.hashSubmittedCoreAt, "2018-06-18T18:08:50Z")
        
        // Branches tests
        XCTAssertEqual(proofResponse.first!.proof!.branches.count, 1)
        XCTAssertEqual(proofResponse.first!.proof!.branches.first!.label, "cal_anchor_branch")
            
            print("ops: \(proofResponse.first!.proof!.branches.first!.ops)")
        }
        catch {
            print("error: \(error)")
        }

    }
}
