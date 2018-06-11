import Alamofire

class DiscoverNodesRequest: BlockchainRequest {

    let discoveryURL: URL

    init(discoveryURL: URL) {
        self.discoveryURL = discoveryURL
    }

    var httpMethod: HTTPMethod {
        return .post
    }

    var url: URL {
        return self.discoveryURL
    }

    var httpBody: [String: Any]? {
        return nil
    }
}
