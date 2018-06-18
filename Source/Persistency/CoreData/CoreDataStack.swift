import CoreData

final class CoreDataStack {

    enum Error: Swift.Error {
        case invalidEntityName(String)
        case unfoundEntity
    }

    let modelName: String

    private(set) lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.privateContext
        return context
    }()

    private lazy var privateContext: NSManagedObjectContext = {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return privateContext
    }()

    private lazy var model: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)

        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        guard let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to Load Document Directory")
        }

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Add Persistent Store")
        }

        return persistentStoreCoordinator
    }()

    init(modelName: String) {
        self.modelName = modelName
        ValueTransformer.setValueTransformer(NodeHashValueTransformer(),
                                             forName: NSValueTransformerName(rawValue: "NodeHashValueTransformer"))
    }

    func save(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Unable to save context: \(context)")
            }
        }
    }

    func saveChanges() {
        self.saveContext.perform {
            do {
                if self.saveContext.hasChanges {
                    try self.saveContext.save()
                }
            } catch {
                print("Failed to saving. Error: \(error.localizedDescription)")
            }

            self.privateContext.perform {
                if self.privateContext.hasChanges {
                    do {
                        try self.privateContext.save()
                    } catch {
                        print("Failed to saving private context. Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
