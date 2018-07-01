import CoreData

final class NodeHashStore: DataStore {

    let entityName: String
    private let mapper: NodeHashToEntityMapper

    init(entityName: String) {
        self.entityName = entityName
        self.mapper = NodeHashToEntityMapper()
        ValueTransformer.setValueTransformer(NodeHashValueTransformer(),
                                             forName: NSValueTransformerName(rawValue: "NodeHashValueTransformer"))
    }
    
    // MARK: Creation

    func createEntity(in context: NSManagedObjectContext) throws -> NodeHashEntity {
        let nodeHashEntity: NodeHashEntity = try self.createEntity(with: self.entityName, in: context)
        return nodeHashEntity
    }
    
    // MARK: Fetching
    
    func fetchEntity(withHash hash: String, in context: NSManagedObjectContext) throws -> NodeHashEntity? {
        let predicate = NSPredicate(format: "value == %@", hash)
        return try self.fetchEntity(withName: self.entityName, in: context, usingPredicate: predicate)
    }
    
    func fetchAllEntities(in context: NSManagedObjectContext) throws -> [NodeHashEntity] {
        return try self.fetchAllEntities(withName: self.entityName, in: context)
    }
    
    // MARK: Deletion
    
    func deleteNodeHashes(in context: NSManagedObjectContext, withCoordinator coordinator: NSPersistentStoreCoordinator) throws {
        try self.deleteAllEntities(withName: self.entityName, in: context, withCoordinator: coordinator)
    }
    
    func delete(nodeHash: NodeHash, in context: NSManagedObjectContext) throws {
        let predicate = NSPredicate(format: "value == %@ AND hashIdentifier == %@", nodeHash.hashValue, nodeHash.hashIdentifier)
        try self.deleteEntity(withName: self.entityName,
                              in: context,
                              usingPredicate: predicate,
                              workaround: NodeHashEntity.self)
    }
    
    func delete(hash: String, in context: NSManagedObjectContext) throws {
        let predicate = NSPredicate(format: "value == %@", hash)
        try self.deleteEntity(withName: self.entityName,
                              in: context,
                              usingPredicate: predicate,
                              workaround: NodeHashEntity.self)
    }
}
