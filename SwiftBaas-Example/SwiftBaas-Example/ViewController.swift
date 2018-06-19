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
//            let hashData = try self.blockchainService.generateSHA256(from: record)
//            self.blockchainService.discoverPublicNodeURLs(completion: nil)
//            self.blockchainService.submit(hashes: [hashData], forNumberOfNodes: 3) { (nodeResult) in
//                print("nodeResult: \(nodeResult)")
//            }
            
            self.blockchainService.proof(forHashId: "3f223780-73fc-11e8-876e-016abea8b406") { (result) in
                print("proof result: \(result)")
            }
        } catch {
            print(error)
        }
    }
}

