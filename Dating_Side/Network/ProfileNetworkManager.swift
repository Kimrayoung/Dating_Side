//
//  ProfileNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 7/30/25.
//

import Foundation

class ProfileNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getUserAnswerList() async throws -> Result<UserAnswersResponse, Error> {
        return await networkManager.callWithAsync(endpoint: ProfileAPIManager.getUserAnswerList, httpCodes: .success)
    }
    
    func fetchUserAccount() async throws -> Result<UserAccount, Error> {
        return await networkManager.callWithAsync(endpoint: ProfileAPIManager.getUserProfile, httpCodes: .success)
    }
}

enum ProfileAPIManager {
    case getUserAnswerList
    case getUserProfile
    
}

extension ProfileAPIManager: APIManager {
    var path: String {
        switch self {
        case .getUserAnswerList:
            return "profile"
        case .getUserProfile:
            return "account"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserAnswerList, .getUserProfile: return .get
        }
    }
    
    var headers: [String : String]? {
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            Log.errorPublic("accessToken이 없음")
            AppState.shared.offAuthenticated()
            AlertManager.shared.loginExpiredAlert()
            return nil
        }
        Log.debugPublic("accessToken", accessToken)
        switch self {
        default:
            return [
                "Content-Type" : "application/json",
                "Authorization" : "Bearer " + accessToken
            ]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        default:
            return nil
        }
    }
}
