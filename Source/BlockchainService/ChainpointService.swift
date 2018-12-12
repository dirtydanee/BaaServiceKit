// TODO: Daniel Metzing - write tests
final class ChainpointService: BlockchainService {
    
    enum Error: Swift.Error {
        case maximumAmountOfNodesExceeded 
    }
    
    typealias BaseNodeURI = URL
    
    private struct Constants {
        static let nodeURLs = [BaseNodeURI(string: "https://a.chainpoint.org/nodes/random")!,
                               BaseNodeURI(string: "https://b.chainpoint.org/nodes/random")!,
                               BaseNodeURI(string: "https://c.chainpoint.org/nodes/random")!]
    }

    private lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.dirtylabs.BaaServiceKit.ChainpointServiceQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

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
    
    // MARK: - Submit
    
    func submit(hashes: [String],
                forNumberOfNodes numberOfNodes: UInt,
                completion: (([Result<[NodeHash]>]) -> Void)?) {
        self.discoverPublicNodeURLs { [weak self] result in
            switch result {
            case .success(let nodes):
                // The maximum number of nodes returned from one discovery is 25
                if numberOfNodes > nodes.count {
                    completion?([.failure(Error.maximumAmountOfNodesExceeded)])
                    return
                }
                self?.submit(hashes: hashes, toNodeURLs: Array(nodes[0..<Int(numberOfNodes)]), completion: completion)
            case .failure(let error):
                completion?([.failure(error)])
            }
        }
    }

    func submit(hashes: [String],
                toNodeURLs urls: [NodeURI],
                completion: (([Result<[NodeHash]>]) -> Void)?) {

        let operations: [SubmitHashOperation] = urls.reduce(into: []) { result, url in
           result.append(SubmitHashOperation(hashes: hashes, url: url, apiClient: self.apiClient))
        }
        let completionOperation = BlockOperation {
            completion?(operations.compactMap { $0.result })
        }

        guard let lastOperation = operations.last else {
            // TODO: Daniel Metzing - Introduce some logging framework
            print("No operation has been created. Skipping to continue")
            return
        }

        completionOperation.addDependency(lastOperation)
        self.queue.addOperations(operations, waitUntilFinished: false, executionOrder: .fifo)
        OperationQueue.main.addOperation(completionOperation)

    }

    // MARK: Proof
    
    func proof(for nodeHashes: [NodeHash],
               completion: (([Result<Proof>]) -> Void)?) {

        let operations: [ProofOperation] = nodeHashes.reduce(into: []) { result, nodeHash in
            nodeHash.urls.forEach { result.append(ProofOperation(nodeHash: nodeHash, url: $0, apiClient: self.apiClient)) }
        }
        let completionOperation = BlockOperation {
            completion?(operations.compactMap { $0.result })
        }

        guard let lastOperation = operations.last else {
            // TODO: Daniel Metzing - Introduce some logging framework
            print("No operation has been created. Skipping to continue")
            return
        }

        completionOperation.addDependency(lastOperation)
        self.queue.addOperations(operations, waitUntilFinished: false, executionOrder: .fifo)
        OperationQueue.main.addOperation(completionOperation)
    }

    // MARK: Configuration

    func configuration(ofNodeAtURL url: URL, completion: ((Result<Node>) -> Void)?) {
        let configurationRequest = ConfigurationRequest(atURL: url)
        self.apiClient.execute(request: configurationRequest) { [weak self] result in
            switch result {
            case .success(let response):
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: response.result)
                    if let error = self?.apiClient.handleErrorIfNeeded(from: data) {
                        completion?(.failure(error))
                        return
                    }
                    
                    let configResponse = try ChainpointConfigResponse.jsonDecoder.decode(ChainpointConfigResponse.self, from: data)
                    let config = Node.Configuration(chainpointConfigResponse: configResponse)
                    let node = Node(publicURL: url, configuation: config)
                    completion?(.success(node))
                    
                } catch let error {
                    completion?(.failure(error))
                }
                
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
