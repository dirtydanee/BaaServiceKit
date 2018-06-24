import CoreData

final class CoreDataStack {    
    let modelName: String
    let storageType: StorageType

    let model: NSManagedObjectModel
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    let writeContext: NSManagedObjectContext
    let readContext: NSManagedObjectContext

    init(modelName: String, storageType: StorageType) throws {
        self.modelName = modelName
        self.storageType = storageType
        let model = try NSManagedObjectModel.makeModel(for: modelName, inBundleForClass: CoreDataStack.self)
        let persistentStoreCoordinator = try NSPersistentStoreCoordinator.makePersistentStoreCoordinator(for: model,
                                                                                                         forStorageType: storageType)

        let writeContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        writeContext.persistentStoreCoordinator = persistentStoreCoordinator
        writeContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        let readContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        readContext.persistentStoreCoordinator = persistentStoreCoordinator

        self.writeContext = writeContext
        self.readContext = readContext
        self.model = model
        self.persistentStoreCoordinator = persistentStoreCoordinator
    }

    func saveChanges() {
        self.writeContext.performAndWait {
            do {
                if self.writeContext.hasChanges {
                    try self.writeContext.save()
                }
            } catch {
                print("Failed to saving. Error: \(error.localizedDescription)")
            }
        }
    }
}
