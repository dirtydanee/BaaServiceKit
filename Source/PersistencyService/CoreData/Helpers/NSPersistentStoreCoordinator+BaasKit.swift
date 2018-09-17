import CoreData

extension NSPersistentStoreCoordinator {

    static func makePersistentStoreCoordinator(for model: NSManagedObjectModel,
                                               forStorageType storageType: StorageType) throws -> NSPersistentStoreCoordinator {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let persistentStoreURL = try NSPersistentStoreCoordinator.setUpPersistentStoreURL(withStorageType: storageType)
        try persistentStoreCoordinator.addPersistentStore(ofType: storageType.stringValue,
                                                          configurationName: nil,
                                                          at: persistentStoreURL,
                                                          options: nil)
        return persistentStoreCoordinator
    }

    private static func setUpPersistentStoreURL(withStorageType type: StorageType) throws -> URL? {
        switch type {
        case .SQLite(let filename):
            guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                throw PersistencyError.documentsURLNotFound
            }
            return documentsDirectoryURL.appendingPathComponent(filename)
        case .inMemory:
            return nil
        }
    }
}
