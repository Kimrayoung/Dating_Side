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
    private let BASE_URL: String = "https://dating.tannding.com/"
    
    init() {
        let config = URLSessionConfiguration.default
        config.httpCookieStorage = HTTPCookieStorage.shared
        config.httpShouldSetCookies = true
        config.httpCookieAcceptPolicy = .always
        self.session = URLSession(configuration: config)
    }
    /// API요청
    /// - Parameters:
    ///   - endpoint: 만들어진  URLRequest
    ///   - httpCodes: 반드시 특정 httpCode가 들어와야 할 경우에 작성(ex, 203만 들어와야 할 경우)
    /// - Returns: 필요한 데이터의 형태로 나감
    func callWithAsync<Value>(endpoint: APIManager, httpCodes: HTTPCodes = .success) async -> Result<Value, Error> where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: BASE_URL)
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let code = httpResponse.statusCode as Int? else {
                throw APIError.unexpectedResponse
            }
            
            if let requestHeader = request.allHTTPHeaderFields {
                print(#fileID, #function, #line, "- requestHeader checking: \(requestHeader)")
            }
            
            // ✅ HTTP 상태코드 체크
            guard httpCodes.contains(code) else {
                if code == HTTPCodes.badRequest || code == HTTPCodes.unauthorized || code == HTTPCodes.notFound || code == HTTPCodes.conflict {
                    let decoder = JSONDecoder()
                    if let errorResponse = try? decoder.decode(APIErrorResponse.self, from: data) {
                        throw APIError.apiError(errorResponse)
                    }
                }
                throw APIError.httpCode(code)
            }
            
            // Authorization 쿠키 추출
            if let headerFields = httpResponse.allHeaderFields as? [String: String],
               let url = request.url {
                
                // 응답에서 쿠키 추출
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                
                // 저 응답에서 Authorization 쿠키를 찾음
                let authCookieValue: String? = cookies.first(where: {
                    $0.domain.contains("dating.tannding.com") && $0.name == "Authorization"
                })?.value
                
                if let authCookieValue = authCookieValue {
                    print("✅ Authorization 쿠키 발견: \(authCookieValue)")
                    if !KeychainManager.shared.saveToken(token: authCookieValue, service: "com.loveway.auth", account: "accessToken") {
                        return .failure(APIError.unexpectedResponse)
                    }
                } else {
//                    print("새로운 Authorization 쿠키를 발급 안됨")
                    // 필요 시 에러를 던지거나 기본값을 설정할 수 있음
                }
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
