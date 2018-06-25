public class SwiftBaas {

    private let hasher: Hasher
    private let apiClient: APIClient
    private let persistencyService: PersistencyService
    private let blockchainService: BlockchainService

    public init() {
        self.hasher = Hasher()
        self.apiClient = APIClient()
        self.persistencyService = CoreDataService(modelName: "Records")
        self.blockchainService = ChainpointService(apiClient: self.apiClient)
    }
}

// MARK: - Database interaction

public extension SwiftBaas {

    func save(hash: NodeHash) throws {

    }

    func hash(for string: String) -> NodeHash? {
        return nil
    }

    func hash(for data: Data) -> NodeHash? {
        return nil
    }

    func storedHashes() throws -> [NodeHash] {
        return []
    }

    func clearHashes() throws {

    }

    func clearHash(withIdentifier: NodeHash) throws {

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

    // MARK: - Proof Verification
    internal func verify(_ proof: Proof, completion: () -> Result<Bool>) {

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
