//
//  Error.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import Foundation

struct APIErrorResponse: Equatable, Codable {
    var message: String
    var error: String
    var status: String
}

