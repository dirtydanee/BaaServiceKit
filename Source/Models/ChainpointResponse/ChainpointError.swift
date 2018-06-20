//
//  ChainpointError.swift
//  Alamofire
//
//  Created by David Szurma on 2018. 06. 20..
//

import Foundation

struct ChainpointError: Codable, Error {
    let code: String
    let message: String
}
