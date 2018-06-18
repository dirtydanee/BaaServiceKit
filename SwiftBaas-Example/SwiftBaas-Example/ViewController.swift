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
        
        let record = Record(identifier: "1", description: self.randomString(length: 7))
        print(record)
        
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
    
    func makeSampleNodeHash() -> [NodeHash] {
        return [NodeHash(hash: "3f05d5a8a1365ffcbc921349dafdf72d78a96993930e2780498dcc5e5113af28",
                  hashIdNode: "aa32ff50-78b6-11e8-88f6-0125005fac04",
                  nodeURIs: [URL(string: "http://45.76.233.183")!])]
    }
}

func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

