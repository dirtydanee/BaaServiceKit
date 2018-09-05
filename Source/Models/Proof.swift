public struct Proof {
    
    let nodeHash: NodeHash
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

        let proof = Proof(nodeHash: nodeHash, metadata: metadata)
        return proof
    }
}
