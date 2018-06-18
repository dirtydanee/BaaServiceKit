final class CoreDataService {

    private let stack: CoreDataStack

    init(modelName: String) {
        self.stack = CoreDataStack(modelName: modelName)
    }
}

extension CoreDataService: PersistencyService {

    func save(hash: NodeHash) throws {

    }

    func hash(for string: String) -> NodeHash? {
        return nil
    }

    func hash(for data: Data) -> NodeHash? {
        return nil
    }

    func storedHashes() throws -> [NodeHash] {
        return []
    }

    func clearHashes() throws {

    }

    func clearHash(withIdentifier: NodeHash) throws {

    }
}
