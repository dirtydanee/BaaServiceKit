import Foundation

struct ChainpointVerifyResponse: Decodable {
    
    struct Anchor: Decodable {
        let branch: String
        let type: String
        let valid: Bool
    }
    
    let proofIndex: Int
    let hash: Hash
    let hashIdNode: String
    let hashSubmittedNodeAt: String //Date
    let hashIdCore: String
    let hashSubmittedCoreAt: String
    let anchors: [ChainpointVerifyResponse.Anchor]
    let status: String // TODO: David Szurma - Could be enum?

    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dataDecodingStrategy = .deferredToData
        return decoder
    }
}
