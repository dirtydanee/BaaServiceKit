import CoreData

final class CoreDataService {

    let stack: CoreDataStack
    let nodeHashStore: NodeHashStore
    let proofStore: ProofStore
    private let nodeHashMapper: NodeHashToEntityMapper
    private let proofMapper: ProofToEntityMapper

    init(coreDataStack: CoreDataStack, nodeHashStore: NodeHashStore, proofStore: ProofStore) {
        self.stack = coreDataStack
        self.nodeHashStore = nodeHashStore
        self.proofStore = proofStore
        self.nodeHashMapper = NodeHashToEntityMapper()
        self.proofMapper = ProofToEntityMapper()
    }
}

// MARK: PersistencyService

extension CoreDataService: PersistencyService {

    // MARK: - NodeHash

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
        try self.nodeHashStore.deleteNodeHashes(in: self.stack.writeContext, withCoordinator: self.stack.persistentStoreCoordinator)
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

    // MARK: - Proofs
    // TODO: Daniel Metzing - Write tests
    func save(proofs: [Proof]) throws {
        for proof in proofs {
            try self.createEntity(from: proof)
        }
        self.saveChanges()
    }

    func proofs(of nodeHash: NodeHash) throws -> [Proof] {
        let entities = try self.proofStore.fetchEntities(with: nodeHash, in: self.stack.readContext)
        return entities.map { self.proofMapper.mapToNewProof(proofEntity: $0) }
    }

    func storedProofs() throws -> [Proof] {
        let entities = try self.proofStore.fetchAllEntities(in: self.stack.readContext)
        return entities.map { self.proofMapper.mapToNewProof(proofEntity: $0) }
    }

    func deleteProofs() throws {
        try self.proofStore.deleteProofs(in: self.stack.writeContext, withCoordinator: self.stack.persistentStoreCoordinator)
        self.saveChanges()
    }

    func deleteProof(proof: Proof) throws {
        try self.proofStore.delete(proof: proof, in: self.stack.writeContext)
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

    @discardableResult
    func createEntity(from proof: Proof) throws -> ProofEntity {
        let entity = try self.proofStore.createEntity(in: self.stack.writeContext)
        return self.proofMapper.map(proof: proof, toProofEntity: entity)
    }
    
    func saveChanges() {
        self.stack.saveChanges()
    }
}
