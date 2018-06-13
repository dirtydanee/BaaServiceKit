import Alamofire

final class SubmitHashRequest: BlockchainRequest {
    let nodeURL: NodeURI
    let hashes: [Hash]

    init(url: NodeURI, hashes: [Hash]) {
        self.nodeURL = url
        self.hashes = hashes
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

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
