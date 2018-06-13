protocol BlockchainServiceInteractor {
    var apiClient: APIClient { get }

    func discoverNodes(completion: @escaping (Result<[NodeURI]>) -> Void)
    func submit(hashes: [String], forNumberOfNodes: UInt, completion: @escaping (Result<[SubmittedHash]>) -> Void)
    func submit(hashes: [String], toNodeURLs urls: [NodeURI], completion: @escaping (Result<[SubmittedHash]>) -> Void)
}
