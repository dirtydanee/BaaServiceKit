import Foundation

// https://bugs.swift.org/browse/SR-4204 due to this error this must be a class type
final class APIErrorTransformer {
    
    /// Data should be JSON
    func tryToParseError(from data: Data) -> Error? {
        do {
            return try JSONDecoder().decode(ChainpointError.self, from: data)
        } catch {
            return nil
        }
    }
}
