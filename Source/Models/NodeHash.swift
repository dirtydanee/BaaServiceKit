public struct NodeHash: Codable, Equatable {
    public let hashValue: Hash
    public let hashIdentifier: Hash
    public let urls: [NodeURI]
    
    static func make(from response: ChainpointHashResponse, url: URL?) -> NodeHash {

        // TODO: David Szurma handle force unwrap
        let hash = response.hashes[0]["hash"]!
        let hashIdNode = response.hashes[0]["hashIdNode"]!
        let baseURL = url?.deletingLastPathComponent()
        return NodeHash(hashValue: hash,
                        hashIdentifier: hashIdNode,
                        urls: [baseURL!])
    }
}
