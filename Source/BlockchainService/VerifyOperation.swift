import Foundation

final class VerifyOperation: AsynchronousOperation {
    
    enum Error: Swift.Error {
        case zeroChainpointProofResponse
    }
    
    let proofs: [Proof]
    let url: NodeURI
    let apiClient: APIClient
    var result: Result<[ProofVerification]>?
    
    init(proofs: [Proof], url: NodeURI, apiClient: APIClient) {
        self.proofs = proofs
        self.url = url
        self.apiClient = apiClient
        super.init()
    }
    
    override func start() {
        super.start()
        
        let proofResponses: [ChainpointProofResponse] = self.proofs.compactMap{ $0.convert() }
        if proofResponses.isEmpty {
            self.result = .failure(Error.zeroChainpointProofResponse)
            self.finish()
            return
        }
        
        let request = VerifyRequest(url: self.url, proofs: proofResponses, headerType: .json)

        print("request: \(request.url)")
        self.apiClient.execute(request: request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
//                    print("VerifyOperation: verify response: \(response.result)")
                    let data = try JSONSerialization.data(withJSONObject: response.result)
                    if let error = strongSelf.apiClient.handleErrorIfNeeded(from: data) {
                        strongSelf.result = .failure(error)
                        print("VerifyOperation: verify error1: \(error)")
                        strongSelf.finish()
                        return
                    }
                    
                    let verificationResponse = try JSONDecoder.chainpoint.decode([ChainpointVerifyResponse].self, from: data)
                    let proofVerifications = verificationResponse.map{ ProofVerification.make(from: $0) }
                    strongSelf.result = .success(proofVerifications)
                    print("VerifyOperation: SUCCESS: \(request.url) - c:\(strongSelf.proofs.count)")
                    for a in proofVerifications {
                        print(" -->   \(a)")
                    }
                } catch {
                    print("VerifyOperation: verify error2: \(error)")
                    strongSelf.result = .failure(error)
                }
                
            case .failure(let error):
                print("VerifyOperation: verify error3: \(error)")
                strongSelf.result = .failure(error)
            }
            DispatchQueue.main.async {
                strongSelf.finish()
            }
        }
    }
}
