import CryptoSwift

public protocol SwiftBaasService {

    func save(hash: HashIdNode) throws
    func storedHashes() throws -> [HashIdNode]
    func clearHashes() throws
    func clearHash(withIdentifier: HashIdNode) throws

    func generateSHA256(from data: Data) -> Data
    func generateSHA256(from string: String) -> String

    func submit(hash: String, completion: () -> Result<HashIdNode>)
    func submit(hash: Data, completion: () -> Result<HashIdNode>)

    func proof(forHashId: HashIdNode, completion: () -> Result<SwiftBaas.Proof>)
    func verify(_ proof: SwiftBaas.Proof, completion: () -> Result<Bool>)
}

public class SwiftBaas {

    public struct Proof {

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

// MARK: - Blockhain interaction

extension SwiftBaas {

    func submit(hashes: [String], completion: () -> Result<[SubmittedHash]>) {
        self.blockchainInteractor.submit(hashes: hashes, completion: completion)
    }

    func submit(hashes: [Data], completion: () ->Result<[SubmittedHash]>) {
        let hexStrings = hashes.map { self.hasher.convertToHexString(data: $0) }
        self.blockchainInteractor.submit(hashes: hexStrings, completion: completion)
    }
}

// MARK: - Hashing

public extension SwiftBaas {

    func generateSHA256(from data: Data) -> Data {
        return self.hasher.sha256(from: data)
    }

    func generateSHA256(from string: String) -> String {
        return self.hasher.sha256(from: string)
    }
}
