import XCTest
@testable import SwiftBaas

class CoreDataServiceBuilderTests: CoreDataTestCase {

    var builder: CoreDataServiceBuilder!

    override func setUp() {
        super.setUp()
        self.builder = CoreDataServiceBuilder()
    }

    override func tearDown() {
        self.builder = nil
        super.tearDown()
    }

    func testBuildingFlow() {
        XCTAssertThrowsError(try builder.build())
        _ = builder.withModelName("Records")
        XCTAssertThrowsError(try builder.build())
        _ = builder.withStorageType(.inMemory)
        XCTAssertThrowsError(try builder.build())
        _ = builder.withNodeHashEntityName("a")
        XCTAssertNoThrow(try builder.build())
    }
}
