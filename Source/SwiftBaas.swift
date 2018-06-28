public class SwiftBaas {

    private let hasher: Hasher
    private let apiClient: APIClient
    private let persistencyService: PersistencyService
    private let blockchainService: BlockchainService

    public init() throws {
        self.hasher = Hasher()
        self.apiClient = APIClient()
        self.persistencyService = try CoreDataServiceBuilder().withModelName("Records")
                                                              .withStorageType(.SQLite(filename: "Records.sqlite"))
                                                              .withNodeHashEntityName("HashNode")
                                                              .build()
        self.blockchainService = ChainpointService(apiClient: self.apiClient)
    }
}

// MARK: - Database interaction

public extension SwiftBaas {
    
    /// Save a node hash
    ///
    /// - Parameter nodeHash: NodeHash instance desired to be saved
    /// - Throws: Errors occuring while saving
    func save(nodeHash: NodeHash) throws {
        try self.persistencyService.save(nodeHashes: [nodeHash])
    }
    
    /// Read a previously saved node hash
    ///
    /// - Parameter hashValue: The hash value of the searched NodeHash instance
    /// - Returns: NodeHash instance with the given hash value if found, otherwise nil
    /// - Throws: Errors while searching for the hash
    func nodeHash(for hashValue: String) throws -> NodeHash? {
        return try self.persistencyService.nodeHash(forHash: hashValue)
    }
    
    /// Read a previously saved node hash
    ///
    /// - Parameter hashData: The hash value of the searched NodeHash instance
    /// - Returns: NodeHash instance with the given hash value if found, otherwise nil
    /// - Throws: Errors while searching for the hash
    func nodeHash(for hashData: Data) throws -> NodeHash? {
        return try self.persistencyService.nodeHash(forHash: hashData.toHexString())
    }
    
    /// Read all previously saved node hashes
    ///
    /// - Returns: A collection of NodeHash instances
    /// - Throws: Errors while collecting all NodeHash instances
    func storedHashes() throws -> [NodeHash] {
        return try self.persistencyService.storedNodeHashes()
    }
    
    /// Delete all stored node hashes
    ///
    /// - Throws: Errors while deleting node hashes
    func deleteHashes() throws {
        try self.persistencyService.deleteNodeHashes()
    }
    
    /// Delete a specific node hash
    ///
    /// - Parameter nodeHash: The NodeHash instances to be deleted
    /// - Throws: Errors while deleting the given node hash
    func delete(_ nodeHash: NodeHash) throws {
        try self.persistencyService.deleteNodeHash(nodeHash)
    }
    
    /// Delete a specific node hash with a given hash
    ///
    /// - Parameter hashValue: The hash value of the NodeHash instance to be deleted
    /// - Throws: Errors while deleting the given node hash
    func delete(forHashValue hashValue: String) throws {
        try self.persistencyService.deleteNodeHash(forHashValue: hashValue)
    }
}

// MARK: - Blockhain interaction

public extension SwiftBaas {

    // MARK: - Nodes discovery

    /// Discover public URLs for submitting hashes using a given blockchain service
    ///
    /// - Parameter completion: On success a collection of URLs to submit hashes to, on failure the description of the occurred error
    func discoverPublicNodeURLs(completion: ((Result<[URL]>) -> Void)?) {
        self.blockchainService.discoverPublicNodeURLs(completion: completion)
    }

    /// Check the configuration of a node at a given URL
    ///
    /// - Parameters:
    ///   - url: The public url of a given node
    ///   - completion: On success a Node object containing the public URL and the configuration, on failure the description of the occurred error
    func configuration(ofNodeAtURL url: URL, completion: ((Result<[Node]>) -> Void)?) {
        self.configuration(ofNodeAtURL: url, completion: completion)
    }

    // MARK: - Hash submission

    /// Submit a collection of hashes as strings to the blockchain to various number of random nodes
    /// It is recommended to submit your hashes to multiple nodes, to be able to retreive the proof even if one would go offline
    ///
    /// - Parameters:
    ///   - hashes: The hashes as a collection of strings to be submitted on the blockchain
    ///   - numberOfNodes: Non negative integer, presenting how many nodes should the hashes be submitted to
    ///   - completion: On success a collection of NodeHash objects containing the public URL of the nodes it was submitted to, on failure the description of the occurred error
    func submit(hashes: [String],
                forNumberOfNodes numberOfNodes: UInt,
                completion: @escaping (Result<[NodeHash]>) -> Void) {
        self.blockchainService.submit(hashes: hashes, forNumberOfNodes: numberOfNodes, completion: completion)
    }

    /// Submit a collection of hashes as strings to the blockchain to various number of random nodes
    /// It is recommended to submit your hashes to multiple nodes, to be able to retreive the proof even if one would go offline
    ///
    /// - Parameters:
    ///   - hashes: The hashes as a collection of binary data to be submitted on the blockchain
    ///   - numberOfNodes: Non negative integer, presenting how many nodes should the hashes be submitted to
    ///   - completion: On success a collection of NodeHash objects containing the public URL of the nodes it was submitted to, on failure the description of the occurred error
    func submit(hashes: [Data],
                forNumberOfNodes numberOfNodes: UInt,
                completion: @escaping (Result<[NodeHash]>) -> Void) {
        let hexStrings = hashes.map { self.hasher.convertToHexString(data: $0) }
        self.blockchainService.submit(hashes: hexStrings, forNumberOfNodes: numberOfNodes, completion: completion)
    }

    /// Submit a collection of hashes as strings to the blockchain to nodes with specific public URLs
    /// It is recommended to submit your hashes to multiple nodes, to be able to retreive the proof even if one would go offline
    ///
    /// - Parameters:
    ///   - hashes: The hashes as a collection of strings to be submitted on the blockchain
    ///   - urls: The public URLs of the nodes where the hashes should be submitted
    ///   - completion: On success a collection of NodeHash objects containing the public URL of the nodes it was submitted to, on failure the description of the occurred error
    func submit(hashes: [String],
                toNodeURLs urls: [NodeURI],
                completion: @escaping (Result<[NodeHash]>) -> Void) {
        self.blockchainService.submit(hashes: hashes, toNodeURLs: urls, completion: completion)
    }

    /// Submit a collection of hashes as strings to the blockchain to nodes with specific public URLs
    /// It is recommended to submit your hashes to multiple nodes, to be able to retreive the proof even if one would go offline
    ///
    /// - Parameters:
    ///   - hashes: The hashes as a collection of binary data to be submitted on the blockchain
    ///   - urls: The public URLs of the nodes where the hashes should be submitted
    ///   - completion: On success a collection of NodeHash objects containing the public URL of the nodes it was submitted to, on failure the description of the occurred error
    func submit(hashes: [Data],
                toNodeURLs urls: [URL],
                completion: @escaping (Result<[NodeHash]>) -> Void) {
        let hexStrings = hashes.map { self.hasher.convertToHexString(data: $0) }
        self.blockchainService.submit(hashes: hexStrings, toNodeURLs: urls, completion: completion)
    }

    /// Retrieve a partial Chainpoint Proof
    ///
    /// - Parameters:
    ///   - nodeHashes:
    ///   - completion: On success a collection of Proof objects
    func proof(for nodeHashes: [NodeHash],
               completion: ((Result<[Proof]>) -> Void)?) {
        self.blockchainService.proof(for: nodeHashes, completion: completion)
    }

    func verify(_ proof: Proof, completion: () -> Result<Bool>) {

    }
}

// MARK: - Hashing

public extension SwiftBaas {

    func generateSHA256(from string: String) -> String {
        return self.hasher.sha256(from: string)
    }

    func generateSHA256(from data: Data) -> Data {
        return self.hasher.sha256(from: data)
    }

    func generateSHA256<T: Encodable>(from encodable: T,
                                      keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) throws -> Data {
        return try self.hasher.sha256(from: encodable, keyEncodingStrategy: keyEncodingStrategy)
    }
}
