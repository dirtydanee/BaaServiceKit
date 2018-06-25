import CoreData

protocol DataStore {
    func createEntity(with name: String, in context: NSManagedObjectContext) throws -> NSEntityDescription
    func fetchEntity<T: NSFetchRequestResult>(withName name: String,
                                              in context: NSManagedObjectContext,
                                              usingPredicate predicate: NSPredicate) throws -> T?
    func fetchAllEntities<T: NSFetchRequestResult>(withName name: String, in context: NSManagedObjectContext) throws -> [T]
}

extension DataStore {
    
    func createEntity<T>(with name: String, in context: NSManagedObjectContext) throws -> T {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: name, in: context) else {
            throw PersistencyError.failedToCreateEntity(name: name)
        }
        
        guard let entity = NSManagedObject(entity: entityDescription, insertInto: context) as? T else {
            throw PersistencyError.invalidEntityType(name: name)
        }
        
        return entity
    }
    
    func fetchEntity<T: NSFetchRequestResult>(withName name: String,
                                              in context: NSManagedObjectContext,
                                              usingPredicate predicate: NSPredicate) throws -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: name)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    func fetchAllEntities<T: NSFetchRequestResult>(withName name: String, in context: NSManagedObjectContext) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: name)
        return try context.fetch(fetchRequest)
    }
    
    func deleteAllEntities(withName name: String,
                           in context: NSManagedObjectContext,
                           withCoordinator coordinator: NSPersistentStoreCoordinator) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        context.perform {
            do {
                try coordinator.execute(deleteRequest, with: context)
            } catch {
                NSLog("Unable to delete hashes. Error: \(error)")
            }
        }
    }
    
    func deleteEntity<T: NSFetchRequestResult>(withName name: String,
                                               in context: NSManagedObjectContext,
                                               usingPredicate predicate: NSPredicate,
                                               workaround: T.Type) throws {
        let fetchRequest = NSFetchRequest<T>(entityName: name)
        fetchRequest.predicate = predicate
        guard let object = try context.fetch(fetchRequest).first as? NSManagedObject else {
            throw PersistencyError.failedToDeleteEntity(name: name, withPredicate: predicate.predicateFormat)
        }
        
        context.delete(object)
    }
}
