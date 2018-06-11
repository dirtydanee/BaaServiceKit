protocol BlockchainServiceInteractor {
    func nodes(completion: () -> Result<[NodeURI]>)
    func submit(hashes: [String], completion: () -> Result<[SubmittedHash]>)
}
