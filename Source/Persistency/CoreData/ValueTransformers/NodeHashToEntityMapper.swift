final class NodeHashToEntityMapper {
    
    func map(nodeHash: NodeHash, toNodeHashEntity entity: NodeHashEntity) -> NodeHashEntity {
        entity.value = nodeHash.hashValue
        entity.hashIdentifier = nodeHash.hashIdentifier
        entity.urls = nodeHash.urls
        return entity
    }
    
    func mapToNewNodeHash(nodeHashEntity entity: NodeHashEntity) -> NodeHash {
        return NodeHash(hashValue: entity.value, hashIdentifier: entity.hashIdentifier, urls: entity.urls)
    }
}
