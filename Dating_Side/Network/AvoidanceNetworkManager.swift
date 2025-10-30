//
//  AvoidanceNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 10/10/25.
//

import Foundation

struct AvoidanceNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getAvoidanceList() async throws -> Result<AvoidanceList, Error> {
        return await networkManager.callWithAsync(endpoint: AvoidanceAPIManger.getAvoidanceList, httpCodes: .success)
    }
    
    func postAvoidanceList(avoidanceList: AvoidanceList) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AvoidanceAPIManger.postAvoidanceList(avoidanceList: avoidanceList), httpCodes: .success)
    }
    
    func deleteAvoidanceList() async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AvoidanceAPIManger.deleteAvoidanceList, httpCodes: .success)
    }
}


enum AvoidanceAPIManger {
    case getAvoidanceList
    case postAvoidanceList(avoidanceList: AvoidanceList)
    case deleteAvoidanceList
}

extension AvoidanceAPIManger: APIManager {
    var path: String {
        return "avoidance"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAvoidanceList: .get
        case .postAvoidanceList: .post
        case .deleteAvoidanceList: .delete
        }
    }
    
    var headers: [String : String]? {
        let accessToken = KeychainManager.shared.getAccessToken()
        Log.debugPublic("accessToken: ", accessToken)
        
        return [
            "Authorization": "Bearer \(accessToken ?? "")",
            "Content-Type" : "application/json",
        ]
    }
    
    func body() throws -> Data? {
        switch self {
        case .postAvoidanceList(let avoidanceList):
            Log.debugPublic("avoidanceList", avoidanceList)
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(avoidanceList)
        default:
            return nil
        }

    }
}
