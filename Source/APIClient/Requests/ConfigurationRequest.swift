import Alamofire

final class ConfigurationRequest: BlockchainRequest {
    
    let configurationURL: URL
    
    init(configurationURL: URL) {
        self.configurationURL = configurationURL
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
