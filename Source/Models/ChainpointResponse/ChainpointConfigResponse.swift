import Foundation

struct ChainpointConfigResponse: Decodable {
    
    struct Calendar: Decodable {
        let height: Int
        let auditResponse: String
    }
    
    let version: String
    let proofExpireMinutes: Int
    let getProofsMaxRest: Int
    let postHashesMax: Int
    let postVerifyProofsMax: Int
    let time: String
    let calendar: ChainpointConfigResponse.Calendar
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dataDecodingStrategy = .deferredToData
        return decoder
    }
}
