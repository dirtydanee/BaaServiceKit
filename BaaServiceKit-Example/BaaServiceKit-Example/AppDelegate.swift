//
//  AppDelegate.swift
//  SwiftBaas-Example
//
//  Created by Daniel.Metzing on 11.06.18.
//  Copyright © 2018 DirtyLabs. All rights reserved.
//

import UIKit
import BaaServiceKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let service = ServiceProvider.shared.blockchainService
        
        //        let path = Bundle(for: type(of: self) as! AnyClass).url(forResource: "PartialFakeProofResponse", withExtension: "json")!
        let file = Bundle.main.path(forResource: "ProofSample", ofType: "json")

        // swiftlint:disable force_try
        let data = try! Data(contentsOf: URL(string: "file://" + file!)!)
        
        let proof = Maker().makeSample(data: data)!
//        let proof2 = Maker().makeSample(data: data, urls: [URL(string: "http://35.236.228.81")!, URL(string: "http://35.236.228.82")!])!
        let proof2 = Maker().makeSample(data: data, urls: [URL(string: "http://35.236.228.81")!, URL(string: "http://54.38.231.134")!])!
        let proof3 = Maker().makeSample(data: data)!

        // 3. Verify proof
        service.verify(proofs: [proof, proof2, proof3], atUrl: nil, completion: { (results) in
            
            for r in results {
                switch r {
                case .success(let proofVerifications):
                    print("SUCCESS !!")
//                    print("proofVerifications: \(proofVerifications)")
//                    for pr in proofVerifications {
//                        print("====> \(pr.status)")
//                        print("\(pr)")
//                    }
                case .failure(let error):
                    print("verify error: \(error)")
                }

            }
        })
        
        
        return true
    }
}

