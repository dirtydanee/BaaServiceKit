final class ChainpointServiceInteractor: BlockchainServiceInteractor {

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

    func nodes(completion: () -> Result<[NodeURI]>) {
        let discoverNodesRequest = DiscoverNodesRequest(discoveryURL: Constants.nodeURLs[0])
        self.apiClient.execute(request: discoverNodesRequest) { result in
            switch result {
            case .success(let response):
                print(response.json)
            case .failure(let error):
                print(error)
            }
        }
    }

    func submit(hashes: [String], completion: () -> Result<[SubmittedHash]>) {
        let submitHashRequest = SubmitHashRequest(url: NodeURI(string: "http://195.201.132.97")!, hashes: hashes)
        self.apiClient.execute(request: submitHashRequest) { result in
            print(result)
        }
    }

    func submit(hashes: [String], forNode nodeURL: NodeURI, completion: () -> Result<[SubmittedHash]>) {
        let submitHashRequest = SubmitHashRequest(url: nodeURL, hashes: hashes)
        self.apiClient.execute(request: submitHashRequest) { result in
            print(result)
        }
    }
}
