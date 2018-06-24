import CoreData

final class CoreDataService {

    let stack: CoreDataStack
    let nodeHashStore: NodeHashStore
    private let nodeHashMapper: NodeHashToEntityMapper

    init(coreDataStack: CoreDataStack, nodeHashStore: NodeHashStore) {
        self.stack = coreDataStack
        self.nodeHashStore = nodeHashStore
        self.nodeHashMapper = NodeHashToEntityMapper()
    }
}

// MARK: PersistencyService

extension CoreDataService: PersistencyService {
    
    func save(nodeHashes: [NodeHash]) throws {
        for nodeHash in nodeHashes {
            try self.createEntity(from: nodeHash)
        }
        self.saveChanges()
    }

    func nodeHash(forHash hashValue: String) throws -> NodeHash? {
        guard let entity = try self.nodeHashStore.fetchEntity(withHash: hashValue, in: self.stack.readContext) else {
            return nil
        }
        return self.nodeHashMapper.mapToNewNodeHash(nodeHashEntity: entity)
    }

    func storedNodeHashes() throws -> [NodeHash] {
        // TODO: Daniel Metzing - think about sorting?
        let entities = try self.nodeHashStore.fetchAllEntities(in: self.stack.readContext)
        let nodeHashes = entities.map { self.nodeHashMapper.mapToNewNodeHash(nodeHashEntity: $0) }
        return nodeHashes
    }

    func deleteNodeHashes() throws {
        try self.nodeHashStore.deleteNodeHashes(in: self.stack.readContext, withCoordinator: self.stack.persistentStoreCoordinator)
        self.saveChanges()
    }

    func deleteNodeHash(_ nodeHash: NodeHash) throws {
        try self.nodeHashStore.delete(nodeHash: nodeHash, in: self.stack.writeContext)
        self.saveChanges()
    }
    
    func deleteNodeHash(forHashValue hashValue: String) throws {
        try self.nodeHashStore.delete(hash: hashValue, in: self.stack.writeContext)
        self.saveChanges()
    }
}

// MARK: Private interface

private extension CoreDataService {
    @discardableResult
    func createEntity(from nodeHash: NodeHash) throws -> NodeHashEntity {
        let entity = try self.nodeHashStore.createEntity(in: self.stack.writeContext)
        return self.nodeHashMapper.map(nodeHash: nodeHash, toNodeHashEntity: entity)
    }
    
    func saveChanges() {
        self.stack.saveChanges()
    }
}
