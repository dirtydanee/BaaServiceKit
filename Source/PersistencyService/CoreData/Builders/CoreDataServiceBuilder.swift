final class CoreDataServiceBuilder {

    private var modelName: String?
    private var storageType: StorageType?
    private var nodeHashEntityName: String?
    private var proofEntityName: String?

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

    func withProofEntityName(_ name: String) -> CoreDataServiceBuilder {
        self.proofEntityName = name
        return self
    }

    func build() throws -> CoreDataService {
        guard let modelName = self.modelName,
              let storageType = self.storageType,
              let nodeHashEntityName = self.nodeHashEntityName,
              let proofEntityName = self.proofEntityName else {
            throw BuilderError.missingParameter
        }
        
        let coreDataStack = try CoreDataStack(modelName: modelName, storageType: storageType)
        let nodeHashStore = NodeHashStore(entityName: nodeHashEntityName)
        let proofStore = ProofStore(entityName: proofEntityName)
        return CoreDataService(coreDataStack: coreDataStack, nodeHashStore: nodeHashStore, proofStore: proofStore)
    }
}
