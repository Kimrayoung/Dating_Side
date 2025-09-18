//
//  MatchingGlobalNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 9/13/25.
//

import Foundation

/// Matching관련에서 전체 앱에서 사용할 API
struct MatchingGlobalNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchMatchingStatus() async throws -> Result<MatchingStatusResponse, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingGlobalAPIManager.matchingStatus, httpCodes: .success)
    }
}

enum MatchingGlobalAPIManager {
    /// 매칭 상태 조회
    case matchingStatus
}

extension MatchingGlobalAPIManager: APIManager {
    var path: String {
        return "matching"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            Log.errorPublic("accessToken이 없음")
            AppState.shared.offAuthenticated()
            AlertManager.shared.loginExpiredAlert()
            return nil
        }
        Log.debugPublic("accessToken", accessToken)
        return [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer " + accessToken
        ]
    }
    
    func body() throws -> Data? {
        return nil
    }
}
