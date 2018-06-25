struct ChainpointHashResponse: Decodable {
    
    struct Meta: Decodable {
        let submittedAt: String
        let processingHints: [String: String]
    }
    
    let meta: ChainpointHashResponse.Meta
    let hashes: [[String: String]]
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dataDecodingStrategy = .deferredToData
        return decoder
    }
}
