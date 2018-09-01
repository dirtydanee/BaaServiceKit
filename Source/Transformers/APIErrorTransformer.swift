import Foundation

// https://bugs.swift.org/browse/SR-4204 due to this error this must be a class type
final class APIErrorTransformer {
    
    /// Data should be JSON
    func parseError(from data: Data) throws -> Error {
        return try JSONDecoder().decode(ChainpointError.self, from: data)
    }
}
