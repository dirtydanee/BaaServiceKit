public struct Proof {
    
    // TODO: David Szurma - Discuss: Is it true for all services?
    public enum Status {
        // Proof after ~15 minutes of submission
        case partial
        // Proof after ~120 minutes of submission
        case full
    }
    
    let hashIdNode: String
    let hash: Hash?
    let status = Proof.Status.partial
    
    static func create(from chainPointProof: ChainpointProofResponse) -> Proof {
        return Proof(hashIdNode: chainPointProof.hashIdNode,
                     hash: chainPointProof.proof?.hash)
    }
}
