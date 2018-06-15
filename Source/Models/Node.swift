public struct Node {

    public struct Configuration {
        let version: String
        let proofExpiration: TimeInterval
        let maxProofRetrieval: UInt
        let maxHashPostal: UInt
        let maxVerifyProofsPostal: UInt
        let systemTime: String
    }

    public let publicURL: URL
    public let configuation: Node.Configuration
}
