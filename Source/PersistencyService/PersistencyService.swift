protocol PersistencyService {

    // MARK: - NodeHash

    func save(nodeHashes: [NodeHash]) throws
    func nodeHash(forHash hashValue: String) throws -> NodeHash?
    func storedNodeHashes() throws -> [NodeHash]
    func deleteNodeHashes() throws
    func deleteNodeHash(_ nodeHash: NodeHash) throws
    func deleteNodeHash(forHashValue hashValue: String) throws

    // MARK: - Proof

    func save(proofs: [Proof]) throws
    func proofs(of nodeHash: NodeHash) throws -> [Proof]
    func storedProofs() throws -> [Proof]
    func deleteProofs() throws
    func deleteProof(proof: Proof) throws
}
