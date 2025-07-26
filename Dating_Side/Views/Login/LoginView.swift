//
//  LoginView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/04/09.
//

import SwiftUI
import os

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var kakaoAuth = KakaoAuth()
    @StateObject var appleAuth = AppleAuth()
    @StateObject var naverAuth = NaverAuth()
    @State var isSelectedB: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("이미 계정이 있으시다면 로그인")
                .font(.pixel(12))
                .foregroundColor(.black)
                .padding(.bottom, 8)
            kakaoLoginBtn
                .padding(.bottom, 8)
            naverLoginBtn
                .padding(.bottom, 8)
            appleLoginBtn
                .padding(.bottom, 88)
        }
        .background(
            Image("bgImg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    var kakaoLoginBtn: some View {
        Button {
            kakaoAuth.handleKakaoLogin()
            kakaoAuth.loginCompletion = { token in
                loginHandler(sociaType: .kakao, token: token)
            }
        } label: {
            Image("kakaoLogin")
        }
        .frame(width: 343, height: 50)
    }
    
    var appleLoginBtn: some View {
        Button {
            appleAuth.startSignInWithAppleFlow()
            appleAuth.loginCompletion = { token in
                loginHandler(sociaType: .apple, token: token)
            }
        } label: {
            Image("appleLogin")
        }
        .frame(width: 343, height: 50)
    }
    
    var naverLoginBtn: some View {
        Button {
            naverAuth.handleNaverLogin()
            naverAuth.loginCompletion = { token in
                loginHandler(sociaType: .naver, token: token)
            }
        } label: {
            Image("naverLogin")
        }
        .frame(width: 343, height: 50)
    }
    
    func loginHandler(sociaType: SocialType, token: String) {
        Task {
            let loginRequest = LoginRequest(userSocialId: token)
            let result = try await AccountNetworkManager().login(userSocialId: loginRequest)
            switch result {
            case .success:
                Log.infoPrivate("로그인 성공", sociaType, token)
                print(#fileID, #function, #line, "- success")
            case .failure(let error):
                let logger = Logger(subsystem: LogSubsystem, category: "Info")
                logger.error("로그인 실패: \(token, privacy: .private)")
                
                Log.infoPublic("로그인 실패", token)
                Log.infoPrivate("로그인 실패🔥", token)
                appState.login(socialType: sociaType, socialId: token) // 로그인 completion 넘겨줌
            }
        }
    }
}

#Preview {
    LoginView()
}
