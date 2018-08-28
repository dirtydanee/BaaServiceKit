import Foundation

final class ProofOperation: AsynchronousOperation {

    let nodeHash: NodeHash
    let url: URL
    let apiClient: APIClient
    var result: Result<Proof>?

    init(nodeHash: NodeHash, url: URL, apiClient: APIClient) {
        self.nodeHash = nodeHash
        self.url = url
        self.apiClient = apiClient
        super.init()
    }

    override func start() {
        super.start()

        let proofRequest = ProofRequest(baseUrl: self.url, hashes: [self.nodeHash.hashIdentifier], headerType: .chainpointLdJson)
        self.apiClient.execute(request: proofRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response.result)
                    if let error = strongSelf.apiClient.handleErrorIfNeeded(from: data) {
                        strongSelf.result = .failure(error)
                        strongSelf.finish()
                        return
                    }

                    let decodedProof = try ChainpointConfigResponse.jsonDecoder.decode([ChainpointProofResponse].self, from: data)
                    let proof = Proof.make(from: decodedProof.first!, with: strongSelf.nodeHash)
                    strongSelf.result = .success(proof)
                } catch {
                    strongSelf.result = .failure(error)
                }

            case .failure(let error):
                strongSelf.result = .failure(error)
            }
            strongSelf.finish()
        }
    }
}
