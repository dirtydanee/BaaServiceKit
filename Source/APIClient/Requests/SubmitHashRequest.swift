import Alamofire

class SubmitHashRequest: BlockchainRequest {
    let nodeURL: NodeURI
    let hashes: [Hash]

    init(url: NodeURI, hashes: [Hash]) {
        self.nodeURL = url
        self.hashes = ["1957db7fe23e4be1740ddeb941ddda7ae0a6b782e536a9e00b5aa82db1e84547"]
    }

    var httpMethod: HTTPMethod {
        return .post
    }

    var url: URL {
        return self.nodeURL
    }

    var httpBody: [String: Any]? {
        return ["hashes": self.hashes]
    }
}
