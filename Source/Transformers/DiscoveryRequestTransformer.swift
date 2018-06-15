final class DiscoveryRequestTransformer: PayloadTransformer {

    func transform(_ _payload: Any) -> Result<[NodeURI]> {

        guard let payload = _payload as? [[String: Any]] else {
            return .failure(TransformerError.invalidPayloadStructure)
        }

        let nodeURIs: [NodeURI] = payload.compactMap { container in
            guard let urlString = container["public_uri"] as? String else {
                return nil
            }

            return NodeURI(string: urlString)
        }

        return .success(nodeURIs)
    }
}
