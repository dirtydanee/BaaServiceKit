protocol PersistencyService {
    func save(hash: NodeHash) throws
    func hash(for string: String) -> NodeHash?
    func hash(for data: Data) -> NodeHash?
    func storedHashes() throws -> [NodeHash]
    func clearHashes() throws
    func clearHash(withIdentifier: NodeHash) throws
}
