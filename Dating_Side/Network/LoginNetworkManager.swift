//
//  LoginNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/04/09.
//

import Foundation
import Combine

/// 핸드폰 인증 관련
struct SMSNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    ///인증코드 발급에 사용할 token
    func getSmsToken() async throws -> Result<SMSTokenResponse, Error> {
        return await networkManager.callWithAsync(endpoint: SMSAPIManager.smsToken, httpCodes: .success)
    }
    
    /// 인증 코드 발급
    func getSmsCode(token: String, smsCodeRequest: SMSCodeRequest) async throws -> Result<SMSCodeResponse, Error> {
        return await networkManager.callWithAsync(endpoint: SMSAPIManager.smsCode(token: token, smsCodeRequest: smsCodeRequest), httpCodes: .success)
    }
    
    /// 인증코드 검증
    func verifySmsCode(smsVerifyRequest: SMSVerifyRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: SMSAPIManager.smsVerify(smsVerifyRequest: smsVerifyRequest), httpCodes: .success)
    }
}

enum SMSAPIManager {
    /// 인증번호 요청에 쓰일 Token
    case smsToken
    /// 인증번호 요청
    case smsCode(token: String, smsCodeRequest: SMSCodeRequest)
    /// 인증번호 검증
    case smsVerify(smsVerifyRequest: SMSVerifyRequest)
}

extension SMSAPIManager: APIManager {
    var path: String {
        switch self {
        case .smsToken, .smsCode:
            "sms"
        case .smsVerify:
            "sms/verify"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .smsToken: return .get
        case .smsCode, .smsVerify: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .smsCode(token, _):
            return  [
                "Content-Type": "application/json",
                "SMS_Authorization": token
            ]
        case .smsToken, .smsVerify:
            return ["Content-Type" : "application/json"]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .smsToken:
            return nil
        case let .smsCode(_, smsCodeRequest):
            let jsonData = try JSONEncoder().encode(smsCodeRequest)
            return jsonData
        case .smsVerify(let smsVerifyRequest):
            let jsonData = try JSONEncoder().encode(smsVerifyRequest)
            return jsonData
        }
    }
}
