import CoreData

final class NodeHashEntity: NSManagedObject {
    @NSManaged var value: String
    @NSManaged var hashIdentifier: String
    @NSManaged var urls: [URL]
    @NSManaged var proofs: [ProofEntity]
}
