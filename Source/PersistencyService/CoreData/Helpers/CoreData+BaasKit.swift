import CoreData

enum StorageType {
    case inMemory
    case SQLite(filename: String)

    var stringValue: String {
        switch self {
        case .inMemory:
            return NSInMemoryStoreType
        case .SQLite:
            return NSSQLiteStoreType
        }
    }
}

enum BuilderError: Swift.Error {
    case missingParameter
}

enum PersistencyError: Swift.Error {
    case failedToCreateEntity(name: String)
    case failedToDeleteEntity(name: String, withPredicate: String)
    case invalidEntityType(name: String)
    case modelNotFound(name: String)
    case urlNotFound(url: URL)
    case documentsURLNotFound
}
