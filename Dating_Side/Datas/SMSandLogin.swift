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

struct SMSTokenResponse: Codable {
    let token: String
}

struct SMSCodeResponse: Codable {
    let code: String
}

struct SMSVerifyRequest: Codable {
    let phoneNumber: String
    let code: String
}

struct SMSCodeRequest: Codable {
    let phoneNumber: String
}

struct LoginRequest: Codable {
    let userSocialId: String
}

enum SocialType: String {
    case naver = "NAVER"
    case kakao = "KAKAO"
    case apple = "APPLE"
}
