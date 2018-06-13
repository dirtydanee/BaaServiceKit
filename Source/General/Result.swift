public enum Result<T> {
    case success(T)
    case failure(Error)
}

public enum TransformerError: Swift.Error {
    case invalidPayloadStructure
}
