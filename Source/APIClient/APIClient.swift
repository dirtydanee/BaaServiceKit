import Alamofire

final class APIClient {

    enum HeaderType {
        case chainpointJson
        
        func value() -> HTTPHeaders {
            switch self {
            case .chainpointJson:
                return [
                    "Content-Type":"application/json",
                    "Accept": "application/vnd.chainpoint.ld+json"
                ]
            }
        }
    }
    
    enum Error: Swift.Error {
        case missingResponseValue
    }
    // TODO: Daniel Metzing - write tests

    func execute(request: BlockchainRequest, headers: HeaderType? = nil, completion: @escaping (Result<APIResponse>) -> Void ) {
        
        Alamofire.request(request.url,
                          method: request.httpMethod,
                          parameters: request.parameters,
                          encoding: request.encoding,
                          headers: headers?.value())
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
}
