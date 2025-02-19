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
    private let BASE_URL: String = "https://api-wmu-dev.angkorcoms.com"
    
    init() {
        self.session = URLSession.shared
    }
    /// API요청
    /// - Parameters:
    ///   - endpoint: 만들어진  URLRequest
    ///   - httpCodes: 반드시 특정 httpCode가 들어와야 할 경우에 작성(ex, 203만 들어와야 할 경우)
    /// - Returns: 필요한 데이터의 형태로 나감
    func callWithAsync<Value>(endpoint: APIManager, httpCodes: HTTPCodes = .success) async -> Result<Value, Error> where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: BASE_URL)
//            print(#fileID, #function, #line, "- request url checking🍂: \(request)")
            let (data, response) = try await session.data(for: request)
            
            guard let code = (response as? HTTPURLResponse)?.statusCode else {
                throw APIError.unexpectedResponse
            }
            
            guard httpCodes.contains(code) else {
                if code == HTTPCodes.badRequest || code == HTTPCodes.unauthorized || code == HTTPCodes.notFound || code == HTTPCodes.conflict{
                    let decoder = JSONDecoder()
                    if let errorResponse = try? decoder.decode(APIErrorResponse.self, from: data) {
                        throw APIError.apiError(errorResponse)
                    }
                }
                
                throw APIError.httpCode(code)
            }
            
            // 데이터가 비어있거나 값이 없는 경우를 처리
//            if Value.self == EmptyResponse.self,
//               let emptyResponse = EmptyResponse() as? Value {
//                return .success(emptyResponse)
//            }
            
            let decoder = JSONDecoder()
            let decodeData = try decoder.decode(Value.self, from: data)
            return .success(decodeData)
        } catch let error {
            return .failure(error)
        }
    }
}
