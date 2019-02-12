import CoreData

final class ProofEntity: NSManagedObject {
    @NSManaged var nodeHash: NodeHashEntity
    @NSManaged var metadata: Data
}
