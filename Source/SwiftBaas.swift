public class SwiftBaas {

    public struct Proof: Equatable {

        public enum Status {
            // Proof after ~15 minutes of submission
            case partial
            // Proof after ~120 minutes of submission
            case full
        }
    }

    private let hasher: Hasher
    private let apiClient: APIClient
    private let blockchainInteractor: BlockchainServiceInteractor

    public init() {
        self.hasher = Hasher()
        let apiClient = APIClient()
        self.apiClient = apiClient
        self.blockchainInteractor = ChainpointServiceInteractor(apiClient: apiClient)
    }
}

// MARK: - Database interaction

public extension SwiftBaas {

    func save(hash: HashIdNode) throws {

    }

    func storedHashes() throws -> [HashIdNode] {
        return []
    }

    func clearHashes() throws {

    }

    func clearHash(withIdentifier: HashIdNode) throws {

    }
}

// MARK: - Blockhain interaction

public extension SwiftBaas {

    // MARK: - Nodes discovery

    func discoverNodes(completion: @escaping (Result<[NodeURI]>) -> Void) {
        self.blockchainInteractor.discoverNodes(completion: completion)
    }

    // MARK: - Hash submission

    func submit(hashes: [String],
                forNumberOfNodes numberOfNodes: UInt,
                completion: @escaping (Result<[SubmittedHash]>) -> Void) {
        self.blockchainInteractor.submit(hashes: hashes, forNumberOfNodes: numberOfNodes, completion: completion)
    }

    func submit(hashes: [Data],
                forNumberOfNodes numberOfNodes: UInt,
                completion: @escaping (Result<[SubmittedHash]>) -> Void) {
        let hexStrings = hashes.map { self.hasher.convertToHexString(data: $0) }
        self.blockchainInteractor.submit(hashes: hexStrings, forNumberOfNodes: numberOfNodes, completion: completion)
    }

    func submit(hashes: [Data],
                toNodeURLs urls: [NodeURI],
                completion: @escaping (Result<[SubmittedHash]>) -> Void) {
        let hexStrings = hashes.map { self.hasher.convertToHexString(data: $0) }
        self.blockchainInteractor.submit(hashes: hexStrings, toNodeURLs: urls, completion: completion)
    }

    func submit(hashes: [String],
                toNodeURLs urls: [NodeURI],
                completion: @escaping (Result<[SubmittedHash]>) -> Void) {
        self.blockchainInteractor.submit(hashes: hashes, toNodeURLs: urls, completion: completion)
    }

    // MARK: - Proof retrieval

    func proof(forHashId: HashIdNode, completion: () -> Result<SwiftBaas.Proof>) {

    }

    // MARK: - Proof Verification

    func verify(_ proof: SwiftBaas.Proof, completion: () -> Result<Bool>) {

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

    func generateSHA256<T>(from encodable: T) throws -> Data where T: Encodable {
        return try self.hasher.sha256(from: encodable)
    }
}
