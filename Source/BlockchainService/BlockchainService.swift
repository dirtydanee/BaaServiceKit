protocol BlockchainService {
    var apiClient: APIClient { get }

    func discoverPublicNodeURLs(completion: ((Result<[URL]>) -> Void)?)
    func submit(hashes: [String], forNumberOfNodes: UInt, completion: ((Result<[NodeHash]>) -> Void)?)
    func submit(hashes: [String], toNodeURLs urls: [NodeURI], completion: ((Result<[NodeHash]>) -> Void)?)
    func proof(for nodeHashes: [NodeHash], completion: (([Result<Proof>]) -> Void)?)
    func configuration(ofNodeAtURL url: URL, completion: ((Result<Node>) -> Void)?)
    func verify(proofs: [Proof], atUrl url: URL?, completion: (([Result<[ProofVerification]>]) -> Void)?)
    // TODO: Daniel Metzing - Discuss: Add support for canceling all requests?
}
