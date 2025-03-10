//
//  LoginField.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import Foundation

enum LoginField {
    case phoneNumber
    case verificationNumber
    
    var focusedValue: Int {
        switch self {
        case .phoneNumber: return 1
        case .verificationNumber: return 2
        }
    }
}
