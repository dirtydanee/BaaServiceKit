import XCTest
@testable import BaaServiceKit

class ProofModelTests: XCTestCase {
    
    func testProofResponse() throws {
        let file = Bundle(for: type(of: self)).url(forResource: "PartialFakeProofResponse", withExtension: "json")!
        
        let data = try Data(contentsOf: file)
        let proofResponse = try JSONDecoder.chainpoint.decode([ChainpointProofResponse].self, from: data)
        
        // Proof reponse root object tests
        XCTAssertEqual(proofResponse.count, 1)
        XCTAssertEqual(proofResponse[0].hashIdNode, "a4b52f60-7322-11e8-876e-0159403461ed")
        XCTAssertEqual(proofResponse[0].anchorsComplete!.count, 1)
        XCTAssertEqual(proofResponse[0].anchorsComplete![0], "cal")
        
        // Proof response proof tests
        XCTAssertEqual(proofResponse[0].proof!.context, URL(string: "https://w3id.org/chainpoint/v3"))
        XCTAssertEqual(proofResponse[0].proof!.type, "Chainpoint")
        XCTAssertEqual(proofResponse[0].proof!.hash, "1957db7fe23e4be1740ddeb941ddda7ae0a6b782e636a9e00b5aa82db1e84547")
        XCTAssertEqual(proofResponse[0].proof!.hashIdNode, "a4b52f60-7322-11e8-876e-0159403461ed")
        XCTAssertEqual(proofResponse[0].proof!.hashSubmittedNodeAt, "2018-06-18T18:08:46Z")
        XCTAssertEqual(proofResponse[0].proof!.hashIdCore, "a73c4f70-7322-11e8-b7ce-019b42e3a86a")
        XCTAssertEqual(proofResponse[0].proof!.hashSubmittedCoreAt, "2018-06-18T18:08:50Z")
        
        // Branches tests
        XCTAssertEqual(proofResponse[0].proof!.branches.count, 1)
        XCTAssertEqual(proofResponse[0].proof!.branches[0].label, "cal_anchor_branch")
        
        print("ops: \(proofResponse[0].proof!.branches[0].ops)")
    }
}
