import CryptoSwift

final class Hasher {

    func sha256(from data: Data) -> Data {
        return data.sha256()
    }

    func sha256(from string: String) -> String {
        return string.sha256()
    }

    func sha256<T: Encodable>(from encodable: T, keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy) throws -> Data {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = keyEncodingStrategy
        let data = try jsonEncoder.encode(encodable)
        return data.sha256()
    }

    func convertToHexString(data: Data) -> String {
        return data.toHexString()
    }
}
