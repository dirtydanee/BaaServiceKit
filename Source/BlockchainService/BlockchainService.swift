protocol BlockchainService {
    var apiClient: APIClient { get }

    func discoverPublicNodeURLs(completion: ((Result<[URL]>) -> Void)?)
    func configuration(ofNodeAtURL url: URL, completion: ((Result<[Node]>) -> Void)?)
    func submit(hashes: [String], forNumberOfNodes: UInt, completion: ((Result<[NodeHash]>) -> Void)?)
    func submit(hashes: [String], toNodeURLs urls: [NodeURI], completion: ((Result<[NodeHash]>) -> Void)?)
    
    func proof(for nodeHashes: [NodeHash], completion: @escaping (Result<[Proof]>) -> Void)
}
