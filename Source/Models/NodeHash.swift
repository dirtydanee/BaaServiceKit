public struct NodeHash: Codable {
    let hash: Hash
    let hashIdNode: HashIdNode
    let nodeURIs: [NodeURI]
    
    static func make(from response: ChainpointHashResponse, url: URL?) -> NodeHash {
        
        let hash = response.hashes[0]["hash"]!
        let hashIdNode = response.hashes[0]["hash_id_node"]!
        let baseURL = url?.deletingLastPathComponent()
        return NodeHash(hash: hash,
                        hashIdNode: hashIdNode,
                        nodeURIs: [baseURL!])
    }
}


// TODO: David Szurma - remove this after example test
extension NodeHash {
    
    public static func createForTest1() -> [NodeHash] {
        return [NodeHash(hash: "eab51abf151cbecc8b77746cac7f35fbbdaa21cde88d49dc4206e3d1b2d4bbf9",
                 hashIdNode: "8605ea20-77e9-11e8-8c84-01c7b0c3b563",
                 nodeURIs: [URL(string: "http://89.36.210.208")!])]
    }
    
    public static func createForTest2() -> [NodeHash] {
        return [
            NodeHash(hash: "eab51abf151cbecc8b77746cac7f35fbbdaa21cde88d49dc4206e3d1b2d4bbf9",
                         hashIdNode: "41104cc0-77ea-11e8-ac88-01c5c054ff27",
                         nodeURIs: [URL(string: "http://144.202.18.156/")!]),
            NodeHash(hash: "eab51abf151cbecc8b77746cac7f35fbbdaa21cde88d49dc4206e3d1b2d4bbf9",
                     hashIdNode: "8605ea20-77e9-11e8-8c84-01c7b0c3b563",
                     nodeURIs: [URL(string: "http://89.36.210.208")!])
        ]
    }
    
    // Same server
    public static func createForTest3() -> [NodeHash] {
        return [
            NodeHash(hash: "1937db7fe23e4ce1740ddeb941ddda7ae0a6b782e536a9e00b5aa82db1e84547",
                     hashIdNode: "ef44e610-77eb-11e8-b424-0144acbdd4c2",
                     nodeURIs: [URL(string: "http://35.230.179.171")!]),
            NodeHash(hash: "1957db7fe23e4ce1740ddeb941ddda7ae0a6b782e536a9e00b5aa82db1e84547",
                     hashIdNode: "e1b44db0-77eb-11e8-b424-0180e134f386",
                     nodeURIs: [URL(string: "http://35.230.179.171")!])
        ]
    }
}
