public struct NodeHash: Codable, Equatable {
    public let hashValue: Hash
    public let hashIdentifier: Hash
    public let urls: [NodeURI]

    public static let f = NodeHash(hashValue: "1", hashIdentifier: "1", urls: [ URL(string: "http://127.0.0.1")!])
}
