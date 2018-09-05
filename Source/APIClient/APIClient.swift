import Alamofire

class APIClient {
    
    private let errorTransformer = APIErrorTransformer()
    
    enum Error: Swift.Error {
        case missingResponseValue
    }
    
    func execute(request: BlockchainRequest, completion: @escaping (Result<APIResponse>) -> Swift.Void ) {
        
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
                        completion(.failure(Error.missingResponseValue))
                        return
                }

                let apiResponse = APIResponse(request: request, result: result)
                completion(.success(apiResponse))
            }
    }
    
    func handleErrorIfNeeded(from data: Data) -> Swift.Error? {
        return try? self.errorTransformer.parseError(from: data)
    }
}
