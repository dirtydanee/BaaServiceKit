//
//  ViewController.swift
//  SwiftBaas-Example
//
//  Created by Daniel.Metzing on 11.06.18.
//  Copyright © 2018 DirtyLabs. All rights reserved.
//

import UIKit
import BaaServiceKit

class ListViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    let blockchainService = try! BaaService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ListViewController {
    func configExample() {
        // Config example
        let configURL = URL(string: "http://35.230.179.171")
        self.blockchainService.configuration(ofNodeAtURL: configURL!) { (result) in
            switch result {
            case .success(let config):

                print("==== CONFIG ====")
                print(config)
                print("==== ====== ====")

            case .failure(let error):
                print(error)
            }
        }
    }

    func nodeExample() {
        let record = Record(identifier: "1", description: String.random(length: 7))
        print(record)

        // Create node example
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
        self.blockchainService.proof(for: nodeHashes) { results in
            for result in results {
                switch result {
                case .success(let proof):
                    print(proof)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
