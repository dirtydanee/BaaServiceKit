public struct ProofVerification {

    public enum Status: String {
        case verified
        case invalid
        case unknown
    }
    
    public let proofIndex: Int
    public let hash: Hash
    public let hashIdNode: String
    public let hashSubmittedNodeAt: String //Date
    public let hashIdCore: String
    public let hashSubmittedCoreAt: String
    public let status: Status
    
    static func make(from chainPointProof: ChainpointVerifyResponse) -> ProofVerification {
        return ProofVerification(proofIndex: chainPointProof.proofIndex,
                                 hash: chainPointProof.hash,
                                 hashIdNode: chainPointProof.hashIdNode,
                                 hashSubmittedNodeAt: chainPointProof.hashSubmittedNodeAt,
                                 hashIdCore: chainPointProof.hashIdCore,
                                 hashSubmittedCoreAt: chainPointProof.hashSubmittedCoreAt,
                                 status: ProofVerification.Status(rawValue: chainPointProof.status) ?? Status.unknown )
    }
}
