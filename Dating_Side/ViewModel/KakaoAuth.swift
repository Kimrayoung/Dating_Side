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
//    var commonAuth = CommonAuth()
    
    var cancellables = Set<AnyCancellable>()
    let encoder = JSONEncoder()
    
    func handleKakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginWithKakaoTalk()
        }
        else {
            kakaoLoginWithKakaoAccount()
        }
    }
    
    //MARK: - 카카오톡 앱으로 로그인
    func kakaoLoginWithKakaoTalk() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {

            } else {
                guard let oauthToken = oauthToken else { return }
                
            }
        }
    }
    
    //MARK: - 카카오 계정으로 로그인
    func kakaoLoginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {

            }
            else {
                guard let oauthToken = oauthToken else { return }
                
                
            }
        }
    } //kakaoLoginWithKaKaoAccount
}
