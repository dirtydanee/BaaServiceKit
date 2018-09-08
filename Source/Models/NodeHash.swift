public struct NodeHash: Codable, Equatable {
    public let hashValue: Hash
    public let hashIdentifier: Hash
    public let urls: [NodeURI]
    
    // TODO: David Szurma - Write tests
    static func make(from response: ChainpointHashResponse, url: URL?) -> [NodeHash] {

        var nodesHashes = [NodeHash]()
        for (index, value) in response.hashes.enumerated() {
            if let hash = value["hash"],
                let hashIdNode = response.hashes[index]["hashIdNode"],
                let baseURL = url?.deletingLastPathComponent() {
            nodesHashes.append(NodeHash(hashValue: hash,
                                        hashIdentifier: hashIdNode,
                                        urls: [baseURL]))
            }
        }

        return nodesHashes
    }
}
