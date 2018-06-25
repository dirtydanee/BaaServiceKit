public struct NodeHash: Codable {
    let hash: Hash
    let hashIdNode: HashIdNode
    let nodeURIs: [NodeURI]
    
    static func make(from response: ChainpointHashResponse, url: URL?) -> NodeHash {
        
        // TODO: David Szurma handle force unwrap
        let hash = response.hashes[0]["hash"]!
        let hashIdNode = response.hashes[0]["hashIdNode"]!
        let baseURL = url?.deletingLastPathComponent()
        return NodeHash(hash: hash,
                        hashIdNode: hashIdNode,
                        nodeURIs: [baseURL!])
    }
}
