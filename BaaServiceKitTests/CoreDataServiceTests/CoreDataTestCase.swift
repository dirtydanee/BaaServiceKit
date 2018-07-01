import XCTest
import CoreData
@testable import BaaServiceKit

class CoreDataTestCase: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var nodeHashStore: NodeHashStore!
    var coreDataService: CoreDataService!
    
    override func setUp() {
        super.setUp()
        self.coreDataStack = try! CoreDataStack(modelName: "Records",
                                                storageType: .inMemory)
        self.nodeHashStore = NodeHashStore(entityName: "NodeHash")
        self.coreDataService = CoreDataService(coreDataStack: self.coreDataStack, nodeHashStore: nodeHashStore)
    }
    
    override func tearDown() {
        self.flushNodeHashData()
        self.coreDataStack = nil
        self.nodeHashStore = nil
        self.coreDataService = nil
        super.tearDown()
    }
    
    func addStubEntities(from nodeHashes: [NodeHash]) {
        
        func createNodeHash(hash: String, hashNodeIdentifier: String, urls: [URL]) {
            let item = NSEntityDescription.insertNewObject(forEntityName: "NodeHash", into: self.coreDataStack.writeContext)
            item.setValue("\(hash)", forKey: "value")
            item.setValue("\(hashNodeIdentifier)", forKey: "hashIdentifier")
            item.setValue(urls, forKey: "urls")
        }
        
        for hash in nodeHashes {
            createNodeHash(hash: hash.hashValue, hashNodeIdentifier: hash.hashIdentifier, urls: hash.urls)
        }
        
        do {
            try self.coreDataStack.writeContext.save()
        } catch {
            print("Error while saving write context. Error: \(error)")
        }
    }
    
    func flushNodeHashData() {
        
        var fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "NodeHash")
        var objs = try! self.coreDataStack.readContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            self.coreDataStack.readContext.delete(obj)
        }
        try? self.coreDataStack.readContext.save()
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NodeHash")
        objs = try! self.coreDataStack.writeContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            self.coreDataStack.writeContext.delete(obj)
        }
        try? self.coreDataStack.writeContext.save()

    }
}
