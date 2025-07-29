//
//  AppleAuth.swift
//  Dating_Side
//
//  Created by 김라영 on 7/7/25.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Security

class AppleAuth: NSObject, ObservableObject {
    var loginCompletion: ((String) -> Void)?
    
    //MARK: - ID토큰이 명시적으로 부여되었는지 확인
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        //nonce생성
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    //MARK: - nonce를 hash하는 코드
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    //MARK: - 애플 로그인 시작
    @available(iOS 13, *)
    @MainActor
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest() //request만들기
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        print(#fileID, #function, #line, "- request: \(request.user)")
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppleAuth: ASAuthorizationControllerDelegate {
     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            let appleAccessToken = idTokenString
            guard let loginCompletion = loginCompletion else { return }
            print(#fileID, #function, #line, "- accessToken checking: \(appleAccessToken)")
            loginCompletion(appleAccessToken)
        }
    }//authorizationController 성공
    
    //MARK: - 애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            
        }
    }
}

