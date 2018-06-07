// TODO: Daniel Metzing - write tests
final class ChainpointServiceInteractor: BlockchainServiceInteractor {
    
    enum Error: Swift.Error {
        case maximumAmountOfNodesExceeded 
    }

    typealias BaseNodeURI = URL

    private struct Constants {
        static let nodeURLs = [BaseNodeURI(string: "https://a.chainpoint.org/nodes/random")!,
                               BaseNodeURI(string: "https://b.chainpoint.org/nodes/random")!,
                               BaseNodeURI(string: "https://c.chainpoint.org/nodes/random")!]
    }

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func discoverPublicNodeURLs(completion: ((Result<[URL]>) -> Void)?) {
        let nodeURLIndex = Int(arc4random_uniform(3))
        let discoverNodesRequest = DiscoverNodesRequest(discoveryURL: Constants.nodeURLs[nodeURLIndex])
        self.apiClient.execute(request: discoverNodesRequest) { result in
            switch result {
            case .success(let response):
                let transformationResult = DiscoveryRequestTransformer().transform(response.result)
                completion?(transformationResult)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func configuration(ofNodeAtURL url: URL, completion: ((Result<[Node]>) -> Void)?) {
        // TODO: Daniel Metzing - Implement me
        // http://nodeURI/config -> see swagger https://app.swaggerhub.com/apis/chainpoint/node/1.0.0#/config
    }

    func submit(hashes: [String],
                forNumberOfNodes numberOfNodes: UInt,
                completion: ((Result<[SubmittedHash]>) -> Void)?) {
        self.discoverPublicNodeURLs { [weak self] result in
            switch result {
            case .success(let nodes):
                // The maximum number of nodes returned from one discovery is 25
                if numberOfNodes > nodes.count {
                    completion?(.failure(Error.maximumAmountOfNodesExceeded))
                    return
                }
                self?.submit(hashes: hashes, toNodeURLs: Array(nodes[0..<Int(numberOfNodes)]), completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func submit(hashes: [String],
                toNodeURLs urls: [NodeURI],
                completion: ((Result<[SubmittedHash]>) -> Void)?) {
        var hashRequestStack = HashRequestStack(hashes: hashes)
        urls.forEach { hashRequestStack.push(SubmitHashRequest(url: $0, hashes: hashes)) }
        self.submitHashRequest(hashRequestStack.pop(),
                               fromStack: hashRequestStack,
                               submittedHashes: [],
                               completion: completion)
    }

    private func submitHashRequest(_ request: SubmitHashRequest?,
                                   fromStack _stack: HashRequestStack,
                                   submittedHashes _hashes: [SubmittedHash],
                                   completion: ((Result<[SubmittedHash]>) -> Void)?) {
        if request == nil {
            completion?(.success(_hashes))
            return
        }

        var stack = _stack
        var hashes = _hashes

        self.apiClient.execute(request: request!) { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                // TODO: Daniel Metzing - Add resposne transformer
                // TODO: Daniel Metzing - Add SubmittedHash here to hashes
                self?.submitHashRequest(stack.pop(), fromStack: stack, submittedHashes: hashes, completion: completion)
            case .failure(let error):
                print(error)
                self?.submitHashRequest(stack.pop(), fromStack: stack, submittedHashes: hashes, completion: completion)
            }
        }
    }
}
