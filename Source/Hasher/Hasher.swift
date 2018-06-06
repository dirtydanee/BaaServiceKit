import CryptoSwift

final class Hasher {

    func sha256(from data: Data) -> Data {
        return data.sha256()
    }

    func sha256(from string: String) -> String {
        return string.sha256()
    }
}
