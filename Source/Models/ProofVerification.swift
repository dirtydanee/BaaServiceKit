public struct ProofVerification {
//    let branch: String
//    let type: String
//    let valid: Bool
    let proofIndex: Int
    let hash: Hash
    let hashIdNode: String
    let hashSubmittedNodeAt: String //Date
    let hashIdCore: String
    let hashSubmittedCoreAt: String
    let status: String
    
    static func make(from chainPointProof: ChainpointVerifyResponse) -> ProofVerification {
        return ProofVerification(proofIndex: chainPointProof.proofIndex,
                                 hash: chainPointProof.hash,
                                 hashIdNode: chainPointProof.hashIdNode,
                                 hashSubmittedNodeAt: chainPointProof.hashSubmittedNodeAt,
                                 hashIdCore: chainPointProof.hashIdCore,
                                 hashSubmittedCoreAt: chainPointProof.hashSubmittedCoreAt,
                                 status: chainPointProof.status)
    }
}
