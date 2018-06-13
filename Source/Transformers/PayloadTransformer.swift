protocol PayloadTransformer {
    associatedtype Transformed
    func transform(_ _payload: Any) -> Result<Transformed>
}
