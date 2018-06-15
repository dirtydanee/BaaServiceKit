protocol BlockchainServiceInteractor {
    var apiClient: APIClient { get }

    func discoverPublicNodeURLs(completion: ((Result<[URL]>) -> Void)?)
    func configuration(ofNodeAtURL url: URL, completion: ((Result<[Node]>) -> Void)?)
    func submit(hashes: [String], forNumberOfNodes: UInt, completion: ((Result<[SubmittedHash]>) -> Void)?)
    func submit(hashes: [String], toNodeURLs urls: [NodeURI], completion: ((Result<[SubmittedHash]>) -> Void)?)
}
