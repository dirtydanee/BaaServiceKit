final class ProofToEntityMapper {
    
    func map(proof: Proof, nodeHashEntity: NodeHashEntity, toProofEntity entity: ProofEntity) -> ProofEntity {

        do {
            entity.nodeHash = nodeHashEntity
            entity.metadata = try JSONSerialization.data(withJSONObject: proof.metadata, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        return entity
    }

    func mapToNewProof(proofEntity entity: ProofEntity) -> Proof {
        let nodeHash = NodeHash(hashValue: entity.nodeHash.value,
                                hashIdentifier: entity.nodeHash.hashIdentifier,
                                urls: entity.nodeHash.urls)
        do {
            // TODO: Daniel Metzing - fix me
            let metadata: [String: Any] = try JSONSerialization
                                              .jsonObject(with: entity.metadata,
                                                          options: .allowFragments) as? [String: Any] ?? [:]
            return Proof(nodeHash: nodeHash, metadata: metadata)
        } catch {
            print(error)
        }
        
        return Proof(nodeHash: nodeHash, metadata: [:])
    }
}
