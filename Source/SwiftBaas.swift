import CryptoSwift

public protocol SwiftBaasService {

    func save(hash: SwiftBaas.HashIdentifier) throws
    func storedHashes() throws -> [SwiftBaas.HashIdentifier]
    func clearHashes() throws
    func clearHash(withIdentifier: SwiftBaas.HashIdentifier) throws

    func generateSHA256(from data: Data) -> Data
    func generateSHA256(from string: String) -> String

    func submit(hash: Any, completion: () -> SwiftBaas.Result<SwiftBaas.HashIdentifier>)
    func proof(forHashId: SwiftBaas.HashIdentifier, completion: () -> SwiftBaas.Result<SwiftBaas.Proof>)
    func verify(_ proof: SwiftBaas.Proof, completion: () -> SwiftBaas.Result<Bool>)
}

public class SwiftBaas {

    public typealias HashIdentifier = String

    public enum Result<T> {
        case success(T)
        case failure
    }

    public struct Proof {

        public enum Status {
            // Proof after ~15 minutes of submission
            case partial
            // Proof after ~120 minutes of submission
            case full
        }
    }

    private let hasher: Hasher

    // TODO: Daniel Metzing - Should it be singleton?
    public init() {
        self.hasher = Hasher()
    }

    public func generateSHA256(from data: Data) -> Data {
        return self.hasher.sha256(from: data)
    }

    public func generateSHA256(from string: String) -> String {
        return self.hasher.sha256(from: string)
    }
}
