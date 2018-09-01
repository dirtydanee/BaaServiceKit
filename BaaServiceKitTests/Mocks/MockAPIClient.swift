//
//  MockAPIClient.swift
//  BaaServiceKitTests
//
//  Created by Daniel Metzing on 26.08.18.
//  Copyright © 2018 DirtyLabs. All rights reserved.
//

import Foundation
@testable import BaaServiceKit

final class MockAPIClient: APIClient {

    var result: Result<APIResponse>?

    override func execute(request: BlockchainRequest, completion: @escaping (Result<APIResponse>) -> Swift.Void) {
        guard let result = self.result else { return }
        completion(result)
    }
}
