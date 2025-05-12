//
//  OnboardingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation

class OnboardingNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func patchOnboardingData(userProfileData: UserProfile) async throws -> Result<ResponseBoolean, Error>  {
        return await networkManager.callWithAsync(endpoint: OnboardingAPIManager.patchUserProfileData(userProfileData: userProfileData), httpCodes: .success)
    }
    
    func fetchOnboardingData() async throws -> Result<UserProfileResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: OnboardingAPIManager.getUserProfile, httpCodes: .success)
    }
}

enum OnboardingAPIManager {
    case getUserProfile
    case patchUserProfileData(userProfileData: UserProfile)
}

extension OnboardingAPIManager: APIManager {
    var path: String {
        switch self {
        case .getUserProfile, .patchUserProfileData:
            return "users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile: return .get
        case .patchUserProfileData: return .patch
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = KeychainManager.shared.getToken(service: "com.loveway.auth", account: "accessToken") {
            return [
                "Content-Type" : "application/json",
                "SMS_Authorization" : "Bearer " + accessToken
            ]
        } else { return nil }
    }
    
    func body() throws -> Data? {
        switch self {
        case .getUserProfile:
            return nil
        case .patchUserProfileData(let userProfileData):
            let patchDic = try userProfileData.asPatchJSON()
            let jsonData = try JSONSerialization.data(withJSONObject: patchDic)
            return jsonData
        }
    }
    
    
}
