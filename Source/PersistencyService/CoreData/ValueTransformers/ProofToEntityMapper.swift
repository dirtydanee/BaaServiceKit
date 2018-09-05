final class ProofToEntityMapper {

    func map(proof: Proof, toProofEntity entity: ProofEntity) -> ProofEntity {
        return entity
    }

    func mapToNewProof(proofEntity entity: ProofEntity) -> Proof {
        let nodeHash = NodeHash(hashValue: entity.nodeHashEntity.value,
                                hashIdentifier: entity.nodeHashEntity.hashIdentifier,
                                urls: entity.nodeHashEntity.urls)
        return Proof(nodeHash: nodeHash, metadata: entity.metaData)
    }
}
