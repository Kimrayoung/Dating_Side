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
    
    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
    }
    
    // 문자전송(로그인을 위한 문자) API(smsAPI를 의미)를 사용하기 위해서는 header에 항상 SMS_Authorization 값 세팅이 필요
    // smsTempToken에 반환되는 값 사용
    func smsBase() async throws -> Result<LoginSMSBase, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.smsBase, httpCodes: .success)
    }
    
    func smsRequest(_ loginSMSRequest: LoginSMSRequest) async throws -> Result<LoginSMSRequest, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.smsRequest(loginSMSRequest: loginSMSRequest), httpCodes: .success)
    }
    
    func smsVerify(_ loginSMSVerify: LoginSMSVerify) async throws -> Result<LoginSMSVerify, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.smsVerify(loginSMSVerify: loginSMSVerify), httpCodes: .success)
    }
    
}

enum LoginAPIManager {
    case smsBase
    case smsRequest(loginSMSRequest: LoginSMSRequest)
    case smsVerify(loginSMSVerify: LoginSMSVerify)
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
        case .smsBase, .smsRequest, .smsVerify:
            return ["Content-Type" : "application/json"]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .smsBase: return nil
        case .smsRequest(let loginSMSRequest):
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(loginSMSRequest)
            return jsonData
        case .smsVerify(let loginSMSVerify):
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(loginSMSVerify)
            return jsonData
        }
    }
}
