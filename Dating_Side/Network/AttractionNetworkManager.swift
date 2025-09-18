//
//  AttractionNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 8/7/25.
//

import Foundation
import Logging

struct AttractionNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 내가 다가가기
    func attraction(attraction: PartnerRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AttractionAPIManager.attraction(attraction: attraction), httpCodes: .success)
    }
    
    /// 내게 다가온 사람 조회
    func senderAttraction() async throws -> Result<AttractionAccountResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AttractionAPIManager.senderAttraction, httpCodes: .success)
    }
    
    /// 내가 다가간 사람 조회
    func receiverAttraction() async throws -> Result<AttractionAccountResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AttractionAPIManager.receiverAttraction, httpCodes: .success)
    }
}

enum AttractionAPIManager {
    /// 내가 다가가기
    case attraction(attraction: PartnerRequest)
    /// 내게 다가온 사람
    case senderAttraction
    /// 내가 다가간 사람
    case receiverAttraction
}

extension AttractionAPIManager: APIManager {
    var path: String {
        switch self {
        case .attraction: return "attraction"
        case .receiverAttraction:
            return "attraction/receiver"
        case .senderAttraction:
            return "attraction/sender"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .attraction: return .post
        default: return .get
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
        case .attraction(let attraction):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(attraction)
        default: return nil
        }
    }
}
