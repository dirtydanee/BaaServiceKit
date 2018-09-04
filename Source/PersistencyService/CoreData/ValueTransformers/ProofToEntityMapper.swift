final class ProofToEntityMapper {

    func map(proof: Proof, toProofEntity entity: ProofEntity) -> ProofEntity {
        entity.status = proof.status.rawValue
        return entity
    }

    func mapToNewProof(proofEntity entity: ProofEntity) -> Proof {
        let nodeHash = NodeHash(hashValue: entity.nodeHashEntity.value,
                                hashIdentifier: entity.nodeHashEntity.hashIdentifier,
                                urls: entity.nodeHashEntity.urls)
        let status = Proof.Status(rawValue: entity.status)
        return Proof(nodeHash: nodeHash, status: status!)
    }
}
