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
    let metadata: [String: Any]
    
    static func make(from chainPointProof: ChainpointProofResponse, with nodeHash: NodeHash) -> Proof {
        
        var metadata = [String: Any]()
        
        do {
            let jsonData = try JSONEncoder().encode(chainPointProof)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let dict = decoded as? [String: Any] {
                metadata = dict
            }
        } catch {
            print("Proof.make -> json error: \(error)")
        }

        let proof = Proof(nodeHash: nodeHash, status: .partial, metadata: metadata)
        return proof
    }
}
