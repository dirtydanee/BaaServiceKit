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
    
    func convert() -> ChainpointProofResponse? {
                
        do {
            let data = try JSONSerialization.data(withJSONObject: self.metadata)
            // TODO: David Szurma - make general jsonDecoder
            return try ChainpointConfigResponse.jsonDecoder.decode(ChainpointProofResponse.self, from: data)
        } catch {
            print("Proof.convert -> json error: \(error)")
        }
        
        return nil
    }
}
