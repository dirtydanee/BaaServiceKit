@testable import BaaServiceKit
import XCTest

class BSKOperationQueueTests: XCTestCase {
    
    func testFifoOrder() {
        let op1 = BlockOperation { sleep(1) }
        let op2 = BlockOperation { sleep(1) }

        let queue = OperationQueue()
        queue.addOperations([op1, op2], waitUntilFinished: false, executionOrder: .fifo)
        XCTAssertEqual(queue.operations.count, 2)
        XCTAssertEqual(queue.operations[0], op1)
        XCTAssertEqual(queue.operations[1], op2)
    }

    func testLifoOrder() {
        let op1 = BlockOperation { sleep(1) }
        let op2 = BlockOperation { sleep(1) }

        let queue = OperationQueue()
        queue.addOperations([op1, op2], waitUntilFinished: false, executionOrder: .lifo)
        XCTAssertEqual(queue.operations.count, 2)
        XCTAssertEqual(queue.operations[0], op2)
        XCTAssertEqual(queue.operations[1], op1)
    }
    
}
