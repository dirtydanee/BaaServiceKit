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
    
    // TODO: David Szurma - support proof request from different endpoints
    func proof(for nodeHashes: [NodeHash],
               completion: ((Result<[Proof]>) -> Void)?) {
        
        // TODO: David Szurma - Handle force unwrap
        let url = nodeHashes.first!.nodeURIs.first!
        let hashes: [Hash] = nodeHashes.reduce(into: []) { (result, nodeHash) in
            return result.append(nodeHash.hashIdNode)
        }
        let proofRequest = ProofRequest(baseUrl: url, hashes: hashes, headerType: .chainpointLdJson)
        self.apiClient.execute(request: proofRequest) { [weak self] result in
            
            switch result {
            case .success(let response):

                do {
                    let data = try JSONSerialization.data(withJSONObject: response.result)
                    if let error = self?.apiClient.handleErrorIfNeeded(from: data) {
                        completion?(.failure(error))
                        return
                    }
                    
                    let decodedProofs = try JSONDecoder().decode([ChainpointProofResponse].self, from: data)
                    var proofs = [Proof]()
                    for decodedProof in decodedProofs {
                        proofs.append(Proof.create(from: decodedProof))
                    }
                    
                    completion?(.success(proofs))
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
        
        // TODO: Throw error somehow
        
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
