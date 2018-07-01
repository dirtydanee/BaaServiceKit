final class CoreDataServiceBuilder {

    private var modelName: String?
    private var storageType: StorageType?
    private var nodeHashEntityName: String?

    func withModelName(_ modelName: String) -> CoreDataServiceBuilder {
        self.modelName = modelName
        return self
    }
    
    func withStorageType(_ storageType: StorageType) -> CoreDataServiceBuilder {
        self.storageType = storageType
        return self
    }

    func withNodeHashEntityName(_ name: String) -> CoreDataServiceBuilder {
        self.nodeHashEntityName = name
        return self
    }

    func build() throws -> CoreDataService {
        guard let modelName = self.modelName,
              let storageType = self.storageType,
              let nodeHashEntityName = self.nodeHashEntityName else {
            throw BuilderError.missingParameter
        }
        
        let coreDataStack = try CoreDataStack(modelName: modelName, storageType: storageType)
        let nodeHashStore = NodeHashStore(entityName: nodeHashEntityName)
        return CoreDataService(coreDataStack: coreDataStack, nodeHashStore: nodeHashStore)
    }
}
