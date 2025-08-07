//
//  ReportNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 8/3/25.
//
import Foundation

struct ReportNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// 유저 신고하기
    func userReport(report: ReportRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: ReportAPIManager.userReport(report: report), httpCodes: .success)
    }
}

enum ReportAPIManager {
    case userReport(report: ReportRequest)
}

extension ReportAPIManager: APIManager {
    var path: String {
        switch self {
        case .userReport:
            return "report"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userReport: .post
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
        case .userReport(let report):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(report)
        }
    }
}
