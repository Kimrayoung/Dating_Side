//
//  AccountNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 7/20/25.
//

import Foundation

class AccountNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func patchUserData(userData: UserData) async throws -> Result<VoidResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.patchUserProfileData(userData: userData), httpCodes: .success)
    }
    
//    func fetchUserData() async throws -> Result<UserProfileResponse, Error>  {
//        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getUserProfile, httpCodes: .success)
//    }
    
    func login(userSocialId: LoginRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.login(userSocialId: userSocialId), httpCodes: .success)
    }
}

enum AccountAPIManager {
    case getUserProfile
    case patchUserProfileData(userData: UserData)
    /// 로그인(소셜로그인 -> 소셜로그인 accessToken 전달 -> 404: 계정 없음)
    case login(userSocialId: LoginRequest)
}

extension AccountAPIManager: APIManager {
    var path: String {
        switch self {
        case .getUserProfile, .patchUserProfileData:
            return "account"
        case .login:
            return "account/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile: return .get
        case .patchUserProfileData: return .patch
        case .login: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [
                "Content-Type" : "application/json",
            ]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .getUserProfile:
            return nil
        case .patchUserProfileData(let userProfileData):
            let patchDic = try userProfileData.asPatchJSON()
            let jsonData = try JSONSerialization.data(withJSONObject: patchDic)
            return jsonData
        case .login(let loginRequest):
            let jsonData = try JSONEncoder().encode(loginRequest)
            return jsonData
        }
    }
    
    
}
