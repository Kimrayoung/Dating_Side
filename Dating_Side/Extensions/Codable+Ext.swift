//
//  Codable+Ext.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation

extension Encodable {
    func asPatchJSON() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data)
        guard let dict = json as? [String: Any] else {
            throw EncodingError.invalidValue(self, .init(codingPath: [], debugDescription: "Failed to convert to dictionary"))
        }
        
        // nil 값을 가진 키 필터링 (Swift에서는 nil이 NSNull로 인코딩됨)
        return dict.filter { $0.value is NSNull == false }
    }
}

extension Encodable {
    func toKeyValuePairs() -> [String: String]? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let dictionary = jsonObject as? [String: Any] else { return nil }

        var result: [String: String] = [:]
        for (key, value) in dictionary {
            // 단순한 값만 문자열로 변환 (Array는 별도 처리 필요)
            if let array = value as? [Any] {
                if let data = try? JSONSerialization.data(withJSONObject: array),
                   let jsonString = String(data: data, encoding: .utf8) {
                    result[key] = jsonString
                }
            } else {
                result[key] = "\(value)"
            }
        }
        return result
    }
}
