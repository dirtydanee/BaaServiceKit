import CryptoSwift

final class Hasher {

    func sha256(from data: Data) -> Data {
        return data.sha256()
    }

    func sha256(from string: String) -> String {
        return string.sha256()
    }

    func sha256<T>(from encodable: T) throws -> Data where T: Encodable {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(encodable)
        return data.sha256()
    }

    func convertToHexString(data: Data) -> String {
        return data.toHexString()
    }
}
