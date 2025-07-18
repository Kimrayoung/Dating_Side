//
//  Data+Ext.swift
//  Dating_Side
//
//  Created by 김라영 on 7/18/25.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
