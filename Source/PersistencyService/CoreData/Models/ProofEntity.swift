import CoreData

final class ProofEntity: NSManagedObject {
    @NSManaged var status: String
    @NSManaged var nodeHashEntity: NodeHashEntity
}
