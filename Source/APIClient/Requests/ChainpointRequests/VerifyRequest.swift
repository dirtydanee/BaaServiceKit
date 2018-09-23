import Alamofire

final class VerifyRequest: BlockchainRequest {
    
    let nodeURL: NodeURI
    let proofs: [ChainpointProofResponse]
    private let headerType: HeaderType
    
    init(url: NodeURI, proofs: [ChainpointProofResponse], headerType: HeaderType) {
        self.nodeURL = url
        self.proofs = proofs
        self.headerType = headerType
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var url: URL {
        return self.nodeURL.appendingPathComponent("verify")
    }
    
    var parameters: [String: Any]? {
        return ["proofs": self.proofs]
    }
    
    var headers: HTTPHeaders? {
        return self.headerType.value()
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
