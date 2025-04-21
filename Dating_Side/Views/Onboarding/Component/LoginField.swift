//
//  LoginField.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import Foundation

enum PhoneNumberField: OneDigitalTextField {
    case phoneNumberFront(Int)
    case phoneNumberBack(Int)
    var index: Int? {
        switch self {
        case .phoneNumberFront(let i): return i
        case .phoneNumberBack(let i): return i
        }
    }
    var isFront: Bool {
        switch self {
        case .phoneNumberFront: return true
        case .phoneNumberBack: return false
        }
    }
}

enum VerificationNumberField: OneDigitalTextField {
    case verificationNumber(Int)
    
    var index: Int? {
        switch self {
        case .verificationNumber(let i): return i
        }
    }
}
