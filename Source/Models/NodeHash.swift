public struct NodeHash: Codable, Equatable {
    public let hashValue: Hash
    public let hashIdentifier: Hash
    public let urls: [NodeURI]
}
