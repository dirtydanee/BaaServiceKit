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
        
        let encode = JSONEncoder()
        encode.dataEncodingStrategy = .deferredToData
        encode.keyEncodingStrategy = .convertToSnakeCase
        
        var metadata = [ [String: Any] ]()
        
        // swiftlint disable: force_try
        for p in self.proofs {
            if let proof = p.proof {
                let jsonData = try! encode.encode(proof)
                let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: [])
                
                if let dict = decoded as? [String: Any] {
                    metadata = metadata + [dict]
                }
            }
        }
        
        return ["proofs": metadata]
    }
    
    var headers: HTTPHeaders? {
        return self.headerType.value()
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
