import XCTest
import CoreData
@testable import BaaServiceKit

class NodeHashToEntityMapperTests: CoreDataTestCase {
    
    var mapper: NodeHashToEntityMapper!
    
    override func setUp() {
        super.setUp()
        self.mapper = NodeHashToEntityMapper()
    }
    
    override func tearDown() {
        self.mapper = nil
        super.tearDown()
    }
    
    
    func testMappingToEntity() throws {
        let nodeHash = NodeHash(hashValue: "10", hashIdentifier: "10", urls: [URL(string: "http://127.0.0.1")!])
        var entity = NSEntityDescription.insertNewObject(forEntityName: "NodeHash", into: self.coreDataStack.writeContext) as! NodeHashEntity
        entity = self.mapper.map(nodeHash: nodeHash, toNodeHashEntity: entity)
        XCTAssertEqual(entity.urls, nodeHash.urls)
        XCTAssertEqual(entity.hashIdentifier, nodeHash.hashIdentifier)
        XCTAssertEqual(entity.value, nodeHash.hashValue)
    }
    
    func testMappingToNodeHash() throws {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "NodeHash", into: self.coreDataStack.writeContext) as! NodeHashEntity
        entity.hashIdentifier = "1"
        entity.value = "1"
        entity.urls = [URL(string: "http://127.0.0.1")!]
        let nodeHash = self.mapper.mapToNewNodeHash(nodeHashEntity: entity)
        XCTAssertEqual(entity.urls, nodeHash.urls)
        XCTAssertEqual(entity.hashIdentifier, nodeHash.hashIdentifier)
        XCTAssertEqual(entity.value, nodeHash.hashValue)
    }
}

