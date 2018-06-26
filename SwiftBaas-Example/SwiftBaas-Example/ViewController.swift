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
        
        let record = Record(identifier: "1", description: self.randomString(length: 7))
        print(record)
        
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
                    // Waiting to create the node on the service
//                    delay(seconds: 20.0, completion: { [weak self] in
//                        self?.proof(for: nodeResults)
//                    })

                     self?.proof(for: NodeHash.makeSampleNodeHash())
                    
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
                    print(proof)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

