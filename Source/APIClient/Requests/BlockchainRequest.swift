import Alamofire

protocol BlockchainRequest {
    var httpMethod: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

extension BlockchainRequest {
    var headers: HTTPHeaders? { return nil }
    var parameters: [String: Any]? { return nil }
}
