import Alamofire

final class APIClient {

    enum Error: Swift.Error {
        case missingResponseValue
        case invalidResponseType
    }

    func execute(request: BlockchainRequest, completion: @escaping (Result<APIResponse>) -> Void ) {

        Alamofire.request(request.url,
                          method: request.httpMethod,
                          parameters: request.httpBody)
            .responseJSON { response in

                guard response.error == nil else {
                    completion(.failure(response.error!))
                    return
                }

                guard response.result.value != nil else {
                    // TODO: Daniel Metzing - Check if the payload is invalid what happens than
                    completion(.failure(Error.missingResponseValue))
                    return
                }

                guard let json = response.result.value as? JSON else {
                    completion(.failure(Error.invalidResponseType))
                    return
                }
                // TODO: Daniel Metzing - try to avoid this force unwrap
                let apiResponse = APIResponse(request: response.request!, json: json)
                completion(.success(apiResponse))
            }
    }
}
