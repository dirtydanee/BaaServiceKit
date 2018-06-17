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

    override func viewDidLoad() {
        super.viewDidLoad()
        let record = Record(identifier: "1", description: "My first record")
        do {
            let blockchainService = try SwiftBaas()
            let hash = try blockchainService.generateSHA256(from: record)
            blockchainService.discoverPublicNodeURLs(completion: nil)
            try blockchainService.save(hash: NodeHash.f)
//          self.blockchainService.submit(hashes: [hash], forNumberOfNodes: 3, completion: nil)
        } catch {
            print(error)
        }
    }
}

