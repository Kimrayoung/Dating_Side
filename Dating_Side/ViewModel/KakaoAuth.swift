//
//  KakaoAuth.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/07/03.
//

import Foundation
import Combine
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

class KakaoAuth: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    let encoder = JSONEncoder()
    
    func handleKakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginWithKakaoTalk()
        } else {
            kakaoLoginWithKakaoAccount()
        }
    }
    
    // MARK: - 카카오톡 앱으로 로그인
    func kakaoLoginWithKakaoTalk() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print("카카오톡 로그인 실패: \(error)")
            } else {
                guard let oauthToken = oauthToken else { return }
                print(#fileID, #function, #line, "- oauthToken checking: \(oauthToken)")
                
                // 로그인 성공 후 사용자 정보 조회
//                self.getUserInfo()
            }
        }
    }
    
    // MARK: - 카카오 계정으로 로그인
    func kakaoLoginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print("카카오 계정 로그인 실패: \(error)")
            } else {
                guard let oauthToken = oauthToken else { return }
                print(#fileID, #function, #line, "- oauthToken checking: \(oauthToken)")
                // 로그인 성공 후 사용자 정보 조회
//                self.getUserInfo()
            }
        }
    }
    
    // MARK: - 사용자 정보 조회
    func getUserInfo() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print("사용자 정보 조회 실패: \(error)")
            } else {
                guard let user = user else { return }
                print("사용자 정보 조회 성공")
                print("닉네임: \(user.kakaoAccount?.profile?.nickname ?? "없음")")
                print("이메일: \(user.kakaoAccount?.email ?? "없음")")
                
                // 여기서 서버로 사용자 정보 전송하거나 다른 로직 수행
                self.handleUserInfo(user: user)
            }
        }
    }
    
    // MARK: - 사용자 정보 처리
    func handleUserInfo(user: User) {
        // 사용자 정보로 서버 통신이나 앱 내 로직 처리
        DispatchQueue.main.async {
            // UI 업데이트 등
        }
    }
    
    #if DEBUG
    deinit {
        print("KakaoAuth deinit됨")
    }
    #endif
}
