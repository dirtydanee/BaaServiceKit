import CoreData

extension NSManagedObjectModel {

    static func makeModel(for name: String, inBundleForClass anyClass: AnyClass) throws -> NSManagedObjectModel {

        guard let modelURL = Bundle(for: anyClass).url(forResource: name, withExtension: "momd") else {
            throw PersistencyError.modelNotFound(name: name)
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            throw PersistencyError.urlNotFound(url: modelURL)
        }

        return managedObjectModel
    }
}
