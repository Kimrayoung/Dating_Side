//
//  LoginNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/04/09.
//

import Foundation
import Combine

/// 로그인 관련 네트워크 파일
class LoginNetworkManager: ObservableObject {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // 문자전송(로그인을 위한 문자) API(smsAPI를 의미)를 사용하기 위해서는 header에 항상 SMS_Authorization 값 세팅이 필요
    // smsTempToken에 반환되는 값 사용
    func smsBase() async throws -> Result<LoginSMSBase, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.smsBase, httpCodes: .success)
    }
    
    // 인증번호 요청
    func smsRequest(_ loginSMSRequest: LoginSMSRequest) async throws -> Result<SMSVerificationNumber, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.smsRequest(loginSMSRequest: loginSMSRequest), httpCodes: .success)
    }
    
    // 인증번호 확인
    func smsVerify(_ loginSMSVerify: LoginSMSVerify, _ smsToken: String) async throws -> Result<ResponseBoolean, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.smsVerify(loginSMSVerify: loginSMSVerify, smsToken: smsToken), httpCodes: .success)
    }
    
}

enum LoginAPIManager {
    case smsBase
    case smsRequest(loginSMSRequest: LoginSMSRequest)
    case smsVerify(loginSMSVerify: LoginSMSVerify, smsToken: String)
}

extension LoginAPIManager: APIManager {
    var path: String {
        switch self {
        case .smsBase:
            return "base"
        case .smsRequest:
            return "sms"
        case .smsVerify:
            return "sms/verify"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .smsBase: return .get
        case .smsRequest, .smsVerify: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .smsBase:
            return ["Content-Type" : "application/json"]
        case .smsRequest(let loginSMSRequest):
            return [
                "Content-Type" : "application/json",
                "SMS_Authorization" : loginSMSRequest.smsToken
            ]
        case let .smsVerify(_, smsToken):
            return [
                "Content-Type" : "application/json",
                "SMS_Authorization" : smsToken
            ]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .smsBase: return nil
        case .smsRequest(let loginSMSRequest):
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(loginSMSRequest)
            return jsonData
        case let .smsVerify(loginSMSVerify, _):
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(loginSMSVerify)
            return jsonData
        }
    }
}
