public struct Proof {
    
    // TODO: David Szurma - Discuss: Is it true for all services?
    public enum Status {
        // Proof after ~15 minutes of submission
        case partial
        // Proof after ~120 minutes of submission
        case full
    }
    
    let nodeHash: NodeHash
    let status: Status
    
    static func make(from chainPointProof: ChainpointProofResponse, with nodeHash: NodeHash) -> Proof {
        return Proof(nodeHash: nodeHash,
                     status: .partial) // TODO: Daniel Metzing - what is the status? Discuss: What should be saved from the response?
    }
}
