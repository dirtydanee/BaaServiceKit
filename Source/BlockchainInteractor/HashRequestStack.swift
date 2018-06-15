// TODO: Daniel Metzing - Write tests
struct HashRequestStack {

    let hashes: [Hash]
    private var requests: [SubmitHashRequest] = []

    init(hashes: [Hash]) {
        self.hashes = hashes
    }

    mutating func push(_ request: SubmitHashRequest) {
        guard request.hashes == self.hashes else {
            fatalError("Stack should only contain requests submitting the same hashes")
        }

        guard !self.requests.contains(where: { $0.url == request.url }) else {
            fatalError("Requests already contains submission of the hash to the given url: \(request.url)")
        }

        self.requests.append(request)
    }

    mutating func pop() -> SubmitHashRequest? {
        return self.requests.popLast()
    }

    func peek() -> SubmitHashRequest? {
        return self.requests.last
    }
}
