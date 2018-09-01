import Foundation

/// Subclass of `Operation` supporting the execution of asynchronous tasks using Swift 4.1
/// Usage:
/// - override the `start` method and make sure to call `super.start()`
/// - once the asynchronous task has finished, call the `finish` method
class AsynchronousOperation: Operation {

    private let lock: NSRecursiveLock
    private var state: State {
        willSet {
            willChangeValue(for: state.keyPath)
            willChangeValue(for: newValue.keyPath)
        }
        didSet {
            didChangeValue(for: state.keyPath)
            didChangeValue(for: oldValue.keyPath)
        }
    }

    override var isAsynchronous: Bool {
        return true
    }

    override var isExecuting: Bool {
        return safeStateConfirmation(of: .executing)
    }

    override var isFinished: Bool {
        return safeStateConfirmation(of: .finished)
    }

    override init() {
        lock = NSRecursiveLock()
        state = .ready
        super.init()
    }

    override func start() {
        super.start()
        guard !self.isCancelled else {
            finish()
            return
        }
        safeStateUpdate(to: .executing)
    }

    func finish() {
        safeStateUpdate(to: .finished)
    }
}

private extension AsynchronousOperation {

    enum State {
        case ready
        case executing
        case finished

        fileprivate var keyPath: KeyPath<AsynchronousOperation, Bool> {
            switch self {
            case .ready:
                return \.isReady
            case .executing:
                return \.isExecuting
            case .finished:
                return \.isFinished
            }
        }
    }
}

private extension AsynchronousOperation {

    func safeStateConfirmation(of state: State) -> Bool {
        let result: Bool
        lock.lock()
        result = self.state == state
        lock.unlock()
        return result
    }

    func safeStateUpdate(to state: State) {
        lock.lock()
        self.state = state
        lock.unlock()
    }
}
