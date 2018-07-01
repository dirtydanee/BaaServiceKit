import XCTest
@testable import BaaServiceKit

class CoreDataServiceTests: CoreDataTestCase {

    func testInsertingNodeHash() throws {
        let url = URL(string: "http://127.0.0.1")!
        let nodeHash = NodeHash(hashValue: "1", hashIdentifier: "1", urls: [url])
        XCTAssertNoThrow(try self.coreDataService.save(nodeHashes: [nodeHash]))
    }
}
