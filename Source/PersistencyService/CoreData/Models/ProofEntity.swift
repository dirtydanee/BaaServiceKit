import CoreData

final class ProofEntity: NSManagedObject {
    @NSManaged var nodeHashEntity: NodeHashEntity
    @NSManaged var metaData: [String: Any]
}
