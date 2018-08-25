import Alamofire

final class ConfigurationRequest: BlockchainRequest {
    
    let configurationURL: URL
    
    init(atURL url: URL) {
        self.configurationURL = url
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var url: URL {
        return self.configurationURL.appendingPathComponent("config")
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}
