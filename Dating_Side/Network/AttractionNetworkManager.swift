//
//  AttractionNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 8/7/25.
//

import Foundation

struct AttractionNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 내가 다가가기
    func attraction(attraction: AttractionRequest) async -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AttractionAPIManager.attraction(attraction: attraction), httpCodes: .success)
    }
    
    /// 내게 다가온 사람 조회
    func senderAttraction() async -> Result<AttractionAccount, Error> {
        return await networkManager.callWithAsync(endpoint: AttractionAPIManager.senderAttraction, httpCodes: .success)
    }
    
    /// 내가 다가간 사람 조회
    func receiverAttraction() async -> Result<AttractionAccount, Error> {
        return await networkManager.callWithAsync(endpoint: AttractionAPIManager.senderAttraction, httpCodes: .success)
    }
}

enum AttractionAPIManager {
    /// 내가 다가가기
    case attraction(attraction: AttractionRequest)
    /// 내게 다가온 사람
    case senderAttraction
    /// 내가 다가간 사람
    case receiverAttraction
}

extension AttractionAPIManager: APIManager {
    var path: String {
        switch self {
        case .attraction: return "/attraction"
        case .receiverAttraction:
            return "/attraction/receiver"
        case .senderAttraction:
            return "/attraction/sender"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .attraction: return .post
        default: return .get
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
        switch self {
        case .attraction(let attraction):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(attraction)
        default: return nil
        }
    }
}
