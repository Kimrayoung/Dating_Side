//
//  LoginField.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import Foundation

enum PhoneNumberField: Hashable {
    case phoneNumberFront(Int)
    case phoneNumberBack(Int)
}

enum VerificationNumberField: Hashable {
    case verificationNumber(Int)
}
