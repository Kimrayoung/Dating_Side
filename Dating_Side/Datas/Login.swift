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
}

struct LoginSMSVerify: Codable {
    let phoneNumber: String
    let number: String
}
