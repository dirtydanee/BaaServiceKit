protocol PersistencyService {
    func save(nodeHashes: [NodeHash]) throws
    func nodeHash(forHash hashValue: String) throws -> NodeHash?
    func storedNodeHashes() throws -> [NodeHash]
    func deleteNodeHashes() throws
    func deleteNodeHash(_ nodeHash: NodeHash) throws
    func deleteNodeHash(forHashValue hashValue: String) throws
}
