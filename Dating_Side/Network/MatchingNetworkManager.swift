//
//  MatchingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 8/9/25.
//

import Foundation


struct MatchingNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func matchingRequest() async throws -> Result<MatchingAccountResponse, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.matchingRequest, httpCodes: .success)
    }
    
    func matchingCancel(score: PartnerScore) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.matchingCancel(score: score), httpCodes: .success)
    }
    
    func matchingComplete(partner: PartnerRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.matchingComplete(attraction: partner), httpCodes: .success)
    }
    
    func matchingPartner() async throws -> Result<MatchingAccountResponse, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.matchingPartner, httpCodes: .success)
    }
    
    
}

enum MatchingAPIManager {
    /// 매칭 요청
    case matchingRequest
    /// 매칭삭제
    case matchingCancel(score: PartnerScore)
    /// 매칭 확정
    case matchingComplete(attraction: PartnerRequest)
    /// 매칭된 상대 정보 조회
    case matchingPartner
    
}

extension MatchingAPIManager: APIManager {
    var path: String {
        switch self {
        case .matchingComplete:
            return "matching/confirm"
        case .matchingPartner:
            return "matching/partner"
        default :
            return "matching"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .matchingPartner:
            return .get
        case .matchingCancel:
            return .delete
        case .matchingRequest, .matchingComplete:
            return .post
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
        return [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer " + accessToken
        ]
    }
    
    func body() throws -> Data? {
        switch self {
        case let .matchingComplete(partnerRequest):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(partnerRequest)
        case let .matchingCancel(score):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(score)
        default:
            return nil
        }
    }
    
    
}
