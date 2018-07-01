import Alamofire

final class ProofRequest: BlockchainRequest {
    
    let baseUrl: URL
    let hashes: [Hash]
    private let headerType: HeaderType
    
    init(baseUrl: URL, hashes: [Hash], headerType: HeaderType) {
        self.baseUrl = baseUrl
        self.hashes = hashes
        self.headerType = headerType
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var url: URL {
        return self.baseUrl.appendingPathComponent("proofs")
    }
    
    var headers: HTTPHeaders? {
        var headerTemp = self.headerType.value()
        
        var hashesHeaderValue = ""
        for (index, hash) in self.hashes.enumerated() {
            
            if index == 0 {
                hashesHeaderValue += hash
            } else {
                hashesHeaderValue += "," + hash

            }
        }
        
        headerTemp["hashids"] = hashesHeaderValue
        return headerTemp
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
}
