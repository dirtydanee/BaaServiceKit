import Foundation

struct ChainpointError: Codable, Error {
    let code: String
    let message: String
}
