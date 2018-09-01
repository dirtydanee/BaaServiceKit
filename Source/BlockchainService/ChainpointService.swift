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
                completion: ((Result<[NodeHash]>) -> Void)?) {
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
                completion: ((Result<[NodeHash]>) -> Void)?) {
        var hashRequestStack = HashRequestStack(hashes: hashes)
        urls.forEach { hashRequestStack.push(SubmitHashRequest(url: $0, hashes: hashes, headerType: .json)) }
        self.submitHashRequest(hashRequestStack.pop(),
                               fromStack: hashRequestStack,
                               submittedHashes: [],
                               completion: completion)
    }
    
    // MARK: Proof
    
    func proof(for nodeHashes: [NodeHash],
               completion: (([Result<Proof>]) -> Void)?) {

        let operations: [ProofOperation] = nodeHashes.reduce(into: []) { results, nodeHash in
            nodeHash.urls.forEach {
                let operation = ProofOperation(nodeHash: nodeHash, url: $0, apiClient: self.apiClient)
                results.append(operation)
            }
        }
        let completionOperation = BlockOperation {
            print(operations)
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

    func configuration(ofNodeAtURL url: URL, completion: ((Result<Config>) -> Void)?) {
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
                    let config = Config(chainpointConfigResponse: configResponse)
                    completion?(.success(config))
                    
                } catch let error {
                    completion?(.failure(error))
                }
                
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

// MARK: - Private methods

private extension ChainpointService {
    
    func submitHashRequest(_ request: SubmitHashRequest?,
                           fromStack _stack: HashRequestStack,
                           submittedHashes _hashes: [NodeHash],
                           completion: ((Result<[NodeHash]>) -> Void)?) {
        if request == nil {
            completion?(.success(_hashes))
            return
        }
        
        var stack = _stack
        var hashes = _hashes
        
        // TODO: David Szurma - Throw error somehow
        self.apiClient.execute(request: request!) { [weak self] result in
            switch result {
            case .success(let response):
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: response.result)
                    
                    if let error = self?.apiClient.handleErrorIfNeeded(from: data) {
                        print(error)
                    }
                    
                    let chainpointHashResponse = try ChainpointHashResponse.jsonDecoder.decode(ChainpointHashResponse.self, from: data)
                    hashes.append(NodeHash.make(from: chainpointHashResponse, url: response.request.url))
                    
                } catch let error {
                    print(error)
                }
            
                self?.submitHashRequest(stack.pop(), fromStack: stack, submittedHashes: hashes, completion: completion)
            case .failure(let error):
                print(error)
                self?.submitHashRequest(stack.pop(), fromStack: stack, submittedHashes: hashes, completion: completion)
            }
        }
    }
}
