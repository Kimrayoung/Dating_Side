//
//  OnboardingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation

class OnboardingNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func patchOnboardingData() {
        
    }
    
    func fetchOnboardingData() {
        
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
        return [
            "Content-Type" : "application/json",
            "SMS_Authorization" : accessToken
        ]
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
