import Alamofire

protocol BlockchainRequest {
    var httpMethod: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
}
