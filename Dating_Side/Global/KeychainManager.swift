//
//  KeychainManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/08.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    // 토큰 저장
    func saveToken(token: String, service: String, account: String) -> Bool {
        // 기존 항목 삭제 (덮어쓰기 용도)
        _ = deleteToken(service: service, account: account)
        
        guard let tokenData = token.data(using: .utf8) else {
            return false
        }
        
        // Keychain에 저장할 쿼리 생성
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        // 추가
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // 토큰 불러오기
    func getToken(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    // 토큰 삭제
    func deleteToken(service: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
