import CoreData

final class ProofStore: DataStore {

    let entityName: String
    private let mapper: ProofToEntityMapper

    init(entityName: String) {
        self.entityName = entityName
        self.mapper = ProofToEntityMapper()
    }

    // MARK: Creation

    func createEntity(in context: NSManagedObjectContext) throws -> ProofEntity {
        let proofEntity: ProofEntity = try self.createEntity(with: self.entityName, in: context)
        return proofEntity
    }

    // MARK: Fetching

    func fetchEntities(with nodeHash: NodeHash, in context: NSManagedObjectContext) throws -> [ProofEntity] {
        let predicate = NSPredicate(format: "nodeHashEntity.value == %@ AND nodeHashEntity.hashIdentifier == %@",
                                    nodeHash.hashValue,
                                    nodeHash.hashIdentifier)
        return try self.fetchEntities(withName: self.entityName, in: context, usingPredicate: predicate)
    }

    func fetchAllEntities(in context: NSManagedObjectContext) throws -> [ProofEntity] {
        return try self.fetchAllEntities(withName: self.entityName, in: context)
    }

    // MARK: Deletion

    func deleteProofs(in context: NSManagedObjectContext, withCoordinator coordinator: NSPersistentStoreCoordinator) throws {
        try self.deleteAllEntities(withName: self.entityName, in: context, withCoordinator: coordinator)
    }

    func delete(proof: Proof, in context: NSManagedObjectContext) throws {
        let predicate = NSPredicate(format: "nodeHashEntity.value == %@ AND nodeHashEntity.hashIdentifier == %@",
                                    proof.nodeHash.hashValue,
                                    proof.nodeHash.hashIdentifier)
        try self.deleteEntity(withName: self.entityName,
                              in: context,
                              usingPredicate: predicate,
                              workaround: ProofEntity.self)
    }
}
