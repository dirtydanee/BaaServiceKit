import Alamofire

final class APIClient {
    
    // TODO: David Szurma - merge APIErrorTransformer Error type
    private let errorTransformer = APIErrorTransformer()
    
    enum Error: Swift.Error {
        case missingResponseValue
    }
    
    // TODO: Daniel Metzing - write tests
    func execute(request: BlockchainRequest, completion: @escaping (Result<APIResponse>) -> Void ) {
        
        Alamofire.request(request.url,
                          method: request.httpMethod,
                          parameters: request.parameters,
                          encoding: request.encoding,
                          headers: request.headers)
            .responseJSON { response in

                guard response.error == nil else {
                    completion(.failure(response.error!))
                    return
                }

                guard let result = response.result.value,
                    let request = response.request else {
                        // TODO: Daniel Metzing - Check if the payload is invalid what happens than
                        completion(.failure(Error.missingResponseValue))
                        return
                }

                let apiResponse = APIResponse(request: request, result: result)
                completion(.success(apiResponse))
            }
    }
    
    func handleErrorIfNeeded(from data: Data) -> Swift.Error? {
        return self.errorTransformer.tryToParseError(from: data)
    }
}
