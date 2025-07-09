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
    func singup(signupRequest: SignupRequest) async throws -> Result<LoginSMSBase, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.signup(signupRequest: signupRequest), httpCodes: .success)
    }
    
    func login(loginRequest: LoginRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: LoginAPIManager.login(loginRequest: loginRequest), httpCodes: .success)
    }
}

enum LoginAPIManager {
    case signup(signupRequest: SignupRequest)
    case login(loginRequest: LoginRequest)
}

extension LoginAPIManager: APIManager {
    var path: String {
        switch self {
        case .signup:
            return "account/signup"
        case .login:
            return "account/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signup, .login: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signup, .login:
            return ["Content-Type" : "application/json"]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case let .signup(signupRequest):
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(signupRequest)
            return jsonData
        case let .login(loginRequest):
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(loginRequest)
            return jsonData
        }
    }
}
