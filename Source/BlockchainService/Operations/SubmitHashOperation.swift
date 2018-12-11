import Foundation

final class SubmitHashOperation: AsynchronousOperation { // TODO: Daniel Metzing - Write tests
    let hashes: [Hash]
    let url: URL
    let apiClient: APIClient
    private(set) var result: Result<[NodeHash]>?

    init(hashes: [Hash], url: URL, apiClient: APIClient) {
        self.hashes = hashes
        self.url = url
        self.apiClient = apiClient
        super.init()
    }

    override func start() {
        super.start()

        let request = SubmitHashRequest(url: url, hashes: hashes, headerType: .json)
        self.apiClient.execute(request: request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response.result)
                    if let error = self?.apiClient.handleErrorIfNeeded(from: data) {
                        strongSelf.result = .failure(error)
                        strongSelf.finish()
                        return
                    }

                    let chainpointHashResponse = try ChainpointHashResponse.jsonDecoder.decode(ChainpointHashResponse.self, from: data)
                    strongSelf.result = .success(NodeHash.make(from: chainpointHashResponse, url: response.request.url))
                } catch {
                    strongSelf.result = .failure(error)
                }

            case .failure(let error):
                self?.result = .failure(error)
            }
            strongSelf.finish()
        }
    }
}
