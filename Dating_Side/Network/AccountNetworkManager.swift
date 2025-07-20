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
    
}

enum AccountAPIManager {
    case getUserProfile
    case patchUserProfileData(userData: UserData)
}

extension AccountAPIManager: APIManager {
    var path: String {
        switch self {
        case .getUserProfile, .patchUserProfileData:
            return "account"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile: return .get
        case .patchUserProfileData: return .patch
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

        }
    }
    
    
}
