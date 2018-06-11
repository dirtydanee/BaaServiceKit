import Alamofire

protocol BlockchainRequest {
    var httpMethod: HTTPMethod { get }
    var httpBody: [String: Any]? { get }
    var url: URL { get }
}
