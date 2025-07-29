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
    
    func getUserAnswerList() async throws -> Result<UserAnswerList, Error> {
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
        case .getUserAnswerList, .getUserProfile: .get
        }
    }
    
    var headers: [String : String]? {
        let accessToken = KeychainManager.shared.getAccessToken()
        return [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer " + accessToken
        ]
    }
    
    func body() throws -> Data? {
        return nil
    }
}
