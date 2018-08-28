import Foundation

extension OperationQueue {

    enum ExecutionOrder {
        case fifo
        case lifo
    }

    func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool, executionOrder: ExecutionOrder) {
        let _ops: [Operation]
        switch executionOrder {
        case .fifo:
            _ops = ops
        case .lifo:
            _ops = ops.reversed()
        }

        for (index, operation) in _ops.enumerated() {
            guard index != 0 else { continue }
            let prevOp = _ops[index - 1]
            operation.addDependency(prevOp)
        }

        self.addOperations(_ops, waitUntilFinished: wait)
    }
}
