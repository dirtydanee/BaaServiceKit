public class BaaService {

    private let hasher: Hasher
    private let apiClient: APIClient
    private let persistencyService: PersistencyService
    private let blockchainService: BlockchainService

    public init() throws {
        self.hasher = Hasher()
        self.apiClient = APIClient()
        self.persistencyService = try CoreDataServiceBuilder().withModelName("Records")
                                                              .withStorageType(.SQLite(filename: "Records.sqlite"))
                                                              .withNodeHashEntityName("NodeHash")
                                                              .withProofEntityName("Proof")
                                                              .build()
        self.blockchainService = ChainpointService(apiClient: self.apiClient)
    }
}

// MARK: - Database interaction

public extension BaaService {
    
    /// Save a node hash
    ///
    /// - Parameter nodeHash: NodeHash instance desired to be saved
    /// - Throws: Errors occuring while saving
    func save(nodeHash: NodeHash) throws {
        try self.persistencyService.save(nodeHashes: [nodeHash])
    }

    /// Save multiple node hashes
    ///
    /// - Parameter nodeHash: NodeHash instances desired to be saved
    /// - Throws: Errors occuring while saving
    func save(nodeHashes: [NodeHash]) throws {
        try self.persistencyService.save(nodeHashes: nodeHashes)
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

    /// Save a proof
    ///
    /// - Parameter proof: Proof instance desired to be saved
    /// - Throws: Errors occuring while saving
    func save(proof: Proof) throws {
        try self.persistencyService.save(proofs: [proof])
    }

    /// Save multiple proofs
    ///
    /// - Parameter proofs: Proof instances desired to be saved
    /// - Throws: Errors occuring while saving
    func save(proofs: [Proof]) throws {
        try self.persistencyService.save(proofs: proofs)
    }

    /// Proof instances for a given nodeHash
    ///
    /// - Parameter nodeHash: The NodeHash instace's saved proofs
    /// - Returns: Collection of Proof instances if found any, otherwise empty array
    /// - Throws: Errors occuring while searching
    func proofs(of nodeHash: NodeHash) throws -> [Proof] {
        return try self.persistencyService.proofs(of: nodeHash)
    }

    /// Read all previously saved proofs
    ///
    /// - Returns: Collection of Proof instances if found any, otherwise empty array
    /// - Throws: Errors occuring while searching
    func storedProofs() throws -> [Proof] {
        return try self.persistencyService.storedProofs()
    }

    /// Delete all stored proofs
    ///
    /// - Throws: Errors while deleting proofs
    func deleteProofs() throws {
        try self.persistencyService.deleteProofs()
    }

    /// Delete a previously saved proof
    ///
    /// - Throws: Errors while deleting proof
    func deleteProof(proof: Proof) throws {
        try self.persistencyService.deleteProof(proof: proof)
    }
}

// MARK: - Blockhain interaction

public extension BaaService {

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
    func configuration(ofNodeAtURL url: URL, completion: ((Result<Node>) -> Void)?) {
        self.blockchainService.configuration(ofNodeAtURL: url, completion: completion)
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
    ///   - nodeHashes: NodeHash object
    ///   - completion: On success a collection of Results holding Proof objects
    func proof(for nodeHashes: [NodeHash],
               completion: (([Result<Proof>]) -> Void)?) {
        self.blockchainService.proof(for: nodeHashes, completion: completion)
    }

    /// Retrive a verification object for proofs, if the url parameter is filled the Proof's request try to reach the verification object from that URL.
    /// If the url parameter is nil, every request try to reach the verification object from related url
    ///
    /// - Parameters:
    ///   - proofs: Proofs objects
    ///   - atUrl: request url for all Proof
    ///   - completion: On success a collection of Results holding ProofVerification objects
    func verify(proofs: [Proof],
                atUrl url: URL?,
                completion: (([Result<[ProofVerification]>]) -> Void)?) {
        self.blockchainService.verify(proofs: proofs, atUrl: url, completion: completion)
    }
}

// MARK: - Hashing

public extension BaaService {

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
