//
//  LoginField.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import Foundation

enum PhoneNumberField: Hashable, Equatable {
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

enum VerificationNumberField: Hashable {
    case verificationNumber(Int)
}
