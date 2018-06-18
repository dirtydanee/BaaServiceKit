@testable import SwiftBaas

extension NodeHash {

    static let fake1 = NodeHash(hashValue: "1", hashIdentifier: "1", urls: [URL(string: "http://127.0.0.1")!])
    static let fake2 = NodeHash(hashValue: "2", hashIdentifier: "2", urls: [URL(string: "http://127.0.0.1")!])
    static let fake3 = NodeHash(hashValue: "3", hashIdentifier: "3", urls: [URL(string: "http://127.0.0.1")!])

    static let allFakes = [NodeHash.fake1, NodeHash.fake2, NodeHash.fake3]
}
