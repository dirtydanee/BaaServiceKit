import Foundation

final class VerifyOperation: AsynchronousOperation {
    
    let proof: Proof
    let url: NodeURI
    let apiClient: APIClient
    var result: Result<ProofVerification>?
    
    init(proof: Proof, url: NodeURI, apiClient: APIClient) {
        self.proof = proof
        self.url = url
        self.apiClient = apiClient
        super.init()
    }
    
    override func start() {
        super.start()
        
        guard let proofResponse = self.proof.convert() else {
//            self.result = .failure(Err)
            self.finish()
            return
        }
        let request = VerifyRequest(url: self.url, proofs: [proofResponse], headerType: .json)

        self.apiClient.execute(request: request) { [weak self] result in
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
                    
                    let verificationResponse = try ChainpointConfigResponse.jsonDecoder.decode(ChainpointVerifyResponse.self, from: data)
                    let proofVerification = ProofVerification.make(from: verificationResponse)
                    strongSelf.result = .success(proofVerification)
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
