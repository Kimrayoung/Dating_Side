//
//  ChatingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 8/24/25.
//

import Foundation

struct ChattingNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func chatting() async throws -> Result<[ChatMessage], Error> {
        return await networkManager.callWithAsync(endpoint: ChatingNetworkManager.chatting, httpCodes: .success)
    }
    
    func chattingRoom() async throws -> Result<ChattingRoomResponse, Error> {
        return await networkManager.callWithAsync(endpoint: ChatingNetworkManager.chattingRoom, httpCodes: .success)
    }
    
    func matchingPartnerPhoto() async throws -> Result<UserImage, Error> {
        return await networkManager.callWithAsync(endpoint: ChatingNetworkManager.matchingPartnerPhoto, httpCodes: .success)
    }
    
    func userReport(report: ReportRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: ChatingNetworkManager.userReport(report: report), httpCodes: .success)
    }
}

enum ChatingNetworkManager {
    case chatting
    case chattingRoom
    /// 매칭된 상태 일자별 프로필 사진 조회
    case matchingPartnerPhoto
    case userReport(report: ReportRequest)
}

extension ChatingNetworkManager: APIManager {
    var path: String {
        switch self {
        case .chatting:
            return "chatting"
        case .chattingRoom:
            return "chatting/chatroom"
        case .matchingPartnerPhoto:
            return "matching/partner/profile-image"
        case .userReport:
            return "report"
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .userReport:
            return .post
        default:
            return .get
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
        case .userReport(let report):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(report)
        case .chatting:
            return nil
        case .chattingRoom:
            return nil
        case .matchingPartnerPhoto:
            return nil
        }
    }
}
