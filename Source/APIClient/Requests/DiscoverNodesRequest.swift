import Alamofire

final class DiscoverNodesRequest: BlockchainRequest {

    let discoveryURL: URL

    init(discoveryURL: URL) {
        self.discoveryURL = discoveryURL
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var url: URL {
        return self.discoveryURL
    }

    var parameters: [String: Any]? {
        return nil
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}
