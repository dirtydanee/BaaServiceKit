//
//  ViewController.swift
//  SwiftBaas-Example
//
//  Created by Daniel.Metzing on 11.06.18.
//  Copyright © 2018 DirtyLabs. All rights reserved.
//

import UIKit
import SwiftBaas

class ViewController: UIViewController {

    var blockchainService = SwiftBaas()

    override func viewDidLoad() {
        super.viewDidLoad()
        let record = Record(identifier: "1", description: "My first record")
        do {
            let hash = try self.blockchainService.generateSHA256(from: record)
            self.blockchainService.discoverPublicNodeURLs(completion: nil)
//            self.blockchainService.submit(hashes: [hash], forNumberOfNodes: 3, completion: nil)
        } catch {
            print(error)
        }
    }
}

