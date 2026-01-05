//
//  NetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import Foundation


protocol NetworkProtocol {
    func callWithAsync<Value>(endpoint: APIManager, httpCodes: HTTPCodes) async -> Result<Value, Error> where Value: Decodable
}

final class NetworkManager: NetworkProtocol {
    static let shared = NetworkManager()
    private let session: URLSession
    private let BASE_URL: String = "https://donvolo.shop/api/"
    
    init() {
        let config = URLSessionConfiguration.default
        config.httpCookieStorage = HTTPCookieStorage.shared
        config.httpShouldSetCookies = true
        config.httpCookieAcceptPolicy = .always
        config.timeoutIntervalForRequest  = 200  // 헤더+바디 전송 완료 최대 120초
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
    }
    /// API요청
    /// - Parameters:
    ///   - endpoint: 만들어진  URLRequest
    ///   - httpCodes: 반드시 특정 httpCode가 들어와야 할 경우에 작성(ex, 203만 들어와야 할 경우)
    /// - Returns: 필요한 데이터의 형태로 나감
    func callWithAsync<Value>(endpoint: APIManager, httpCodes: HTTPCodes = .success) async -> Result<Value, Error> where Value: Decodable {
        Log.debugPublic("accessToken checking", endpoint.headers?["Authorization"] ?? "")
        
        do {
            let request = try endpoint.urlRequest(baseURL: BASE_URL)
            
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  let code = httpResponse.statusCode as Int? else {
                throw APIError.unexpectedResponse(nil)
            }
            
            Log.debugPublic("http code 결과", code)
            
            // ✅ HTTP 상태코드 체크
            guard httpCodes.contains(code) else {
                if code == HTTPCodes.loginExpired { // 로그인 만료
                    DispatchQueue.main.async {
                        AppState.shared.offAuthenticated()
                        AlertManager.shared.loginExpiredAlert()
                    }
                    throw APIError.loginExpired
                } else if HTTPCodes.clientError.contains(code) { // 그 외 클라이언트 에러
                    let decoder = JSONDecoder()
                    if let errorResponse = try? decoder.decode(APIErrorResponse.self, from: data) {
                        throw APIError.apiError(errorResponse)
                    } else {
                        throw APIError.unexpectedResponse(code)
                    }
                } else if HTTPCodes.serverError.contains(code) { // 서버에러
                    DispatchQueue.main.async {
                        AlertManager.shared.serverAlert()
                    }
                    throw APIError.serverError(code)
                }
                throw APIError.httpCode(code)
            }
            
            // accessToken 저장
            if let accessToken = httpResponse.value(forHTTPHeaderField: "x-access-token") {
                Log.debugPrivate("Access Token: \(accessToken)")
                if !KeychainManager.shared.saveToken(token: accessToken, service: "com.loveway.auth", account: "accessToken") {
                    return .failure(APIError.unexpectedResponse(nil))
                }
            } else {
                Log.errorPublic("x-access-token not found in headers.")
            }
            
            if data.isEmpty {
                // Value 타입이 VoidResponse일 때만 처리
                if Value.self == VoidResponse.self {
                    // 강제 캐스팅이지만, VoidResponse.self == Value.self이 보장됨
                    return .success(VoidResponse() as! Value)
                }
                // 다른 타입인데 바디가 비어 있으면 에러 처리
                throw APIError.unexpectedResponse(nil)
            }
            
            // 실제 데이터 디코딩
            let decoder = JSONDecoder()
            let decodeData = try decoder.decode(Value.self, from: data)
            return .success(decodeData)
            
        } catch let error {
            return .failure(error)
        }
    }
    
}
