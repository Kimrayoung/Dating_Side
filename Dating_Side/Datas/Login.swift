//
//  Login.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/04/09.
//

import Foundation

struct LoginSMSBase: Codable {
    let appVersion, smsTempToken: String?
}

struct LoginSMSRequest: Codable {
    let phoneNumber: String
    let smsToken: String
}

struct SMSVerificationNumber: Codable {
    let number: Int
}

struct LoginSMSVerify: Codable {
    let phoneNumber: String
    let number: String
}


