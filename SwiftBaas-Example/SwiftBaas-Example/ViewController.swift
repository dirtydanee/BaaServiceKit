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
            
            // 1. Generate SHA-256
            let hashData = try self.blockchainService.generateSHA256(from: record)
            
            // 2. Discover node URLs
            self.blockchainService.discoverPublicNodeURLs(completion: nil)
            
            // 3. Submit hashes
            self.blockchainService.submit(hashes: [hashData], forNumberOfNodes: 1) {  [weak self] (result) in
                 
                switch result {
                case .success(let nodeResults):
                    
                    // 4. Proof for submitted hashes
                    // self?.proof(for: nodeResults)
                    
                    let node1 = NodeHash.createForTest3()
                    self?.proof(for: node1)

                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func proof(for nodeHashes: [NodeHash]) {
        self.blockchainService.proof(for: nodeHashes) { (result) in
            switch result {
            case .success(let proofs):
                for proof in proofs {
                    print("=: \(proof)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

