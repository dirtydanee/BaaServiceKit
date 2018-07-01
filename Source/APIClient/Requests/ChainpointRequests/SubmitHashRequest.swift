import Alamofire

final class SubmitHashRequest: BlockchainRequest {

    let nodeURL: NodeURI
    let hashes: [Hash]
    private let headerType: HeaderType

    init(url: NodeURI, hashes: [Hash], headerType: HeaderType) {
        self.nodeURL = url
        self.hashes = hashes
        self.headerType = headerType
    }

    var httpMethod: HTTPMethod {
        return .post
    }

    var url: URL {
        return self.nodeURL.appendingPathComponent("hashes")
    }

    var parameters: [String: Any]? {
        return ["hashes": self.hashes]
    }
    
    var headers: HTTPHeaders? {
        return self.headerType.value()
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
