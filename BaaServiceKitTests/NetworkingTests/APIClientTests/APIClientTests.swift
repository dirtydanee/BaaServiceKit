//
//  APIClientTests.swift
//  BaaServiceKitTests
//
//  Created by Daniel Metzing on 26.08.18.
//  Copyright © 2018 DirtyLabs. All rights reserved.
//

import XCTest
@testable import BaaServiceKit
// TODO: Daniel Metzing - Discuss: How could we mock the responses from Alamofire?
class APIClientTests: XCTestCase {

    var apiClient: APIClient!

    override func setUp() {
        super.setUp()
        self.apiClient = APIClient()
    }
    
    override func tearDown() {
        self.apiClient = nil
        super.tearDown()
    }
}
