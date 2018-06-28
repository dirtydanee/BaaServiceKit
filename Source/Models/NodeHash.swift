public struct NodeHash: Codable {
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
    
    // TODO: David Szurma - Discuss this: How we can provide sample [NodeHash] if we would like to keep the init: private for the framework
    public static func makeSampleNodeHash() -> [NodeHash] {
        return [NodeHash(hashValue: "3f05d5a8a1365ffcbc921349dafdf72d78a96993930e2780498dcc5e5113af28",
                         hashIdentifier: "aa32ff50-78b6-11e8-88f6-0125005fac04",
                         urls: [URL(string: "http://45.76.233.183")!])]
    }
}
