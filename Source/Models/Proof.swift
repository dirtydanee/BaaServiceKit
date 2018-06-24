//
//  Proof.swift
//  Alamofire
//
//  Created by David Szurma on 2018. 06. 20..
//

import Foundation

public struct Proof {
    
    public enum Status {
        // Proof after ~15 minutes of submission
        case partial
        // Proof after ~120 minutes of submission
        case full
    }
    
    let hashIdNode: String
    let hash: Hash?
    
    static func create(from chainPointProof: ChainpointProofResponse) -> Proof {
        return Proof(hashIdNode: chainPointProof.hashIdNode,
                     hash: chainPointProof.proof?.hash)
    }
}
