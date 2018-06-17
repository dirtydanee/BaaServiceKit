import XCTest
import CoreData
@testable import SwiftBaas

class CoreDataTestCase: XCTestCase {
    
    struct FakeNodeHashes {
        static let fake1 = NodeHash(hashValue: "1", hashIdentifier: "1", urls: [URL(string: "http://127.0.0.1")!])
        static let fake2 = NodeHash(hashValue: "2", hashIdentifier: "2", urls: [URL(string: "http://127.0.0.1")!])
        static let fake3 = NodeHash(hashValue: "3", hashIdentifier: "3", urls: [URL(string: "http://127.0.0.1")!])
        
        static let allFakes = [FakeNodeHashes.fake1, FakeNodeHashes.fake2, FakeNodeHashes.fake3]
    }
    
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
