//
//  APIManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import Foundation

///API관련
protocol APIManager {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String]? { get }
    func body() throws -> Data?
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200..<300
    static let badRequest = 400
    static let unauthorized = 401
    static let notFound = 402
    static let conflict = 409
    static let serverError = 500..<600
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

///API에러
enum APIError: Error, Equatable {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case networkError
    case apiError(APIErrorResponse)
//    case imageDeserialization
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "잘못된 URL입니다."
        case .httpCode(let status): return "Unexpected status code: \(status)"
        case .unexpectedResponse: return "서버로 부터 잘못된 응답을 받았습니다."
        case .networkError: return "인터넷 연결이 끊어졌습니다.\n네트워크 상태를 확인해주세요."
        case .apiError(let error):
            return error.errorMessage
        }
    }
}


extension APIManager {
    //MARK: - make request
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else { throw
            APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        
        return request
    }
}
