import Foundation

enum HeaderType {
    
    case json
    case chainpointLdJson
    
    func value() -> [String: String] {
        
        switch self {
        case .json:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        case .chainpointLdJson:
            return [
                "Accept": "application/vnd.chainpoint.ld+json"
            ]
        }

    }
}
