import Alamofire

final class ProofRequest: BlockchainRequest {
    
    let baseUrl: URL
    let hash: Hash
    
    init(baseUrl: URL, hash: Hash) {
        self.baseUrl = baseUrl
        self.hash = hash
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var url: URL {
        return self.baseUrl.appendingPathComponent("proofs").appendingPathComponent(self.hash)
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}
