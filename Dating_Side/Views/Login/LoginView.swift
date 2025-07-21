//
//  LoginView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/04/09.
//

import SwiftUI

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
//            SelectButtonLabel(isSelected: $isSelectedB, height: 48, text: "전화번호로 시작하기", backgroundColor: .white, selectedBackgroundColor: .white, textColor: .black, selectedTextColor: .black, cornerRounded: 8, font: .pixel(16), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0, strokeBorderLineColor: .white, selectedStrokeBorderColor: .white)
//                .padding(.bottom, 88)
//                .padding(.horizontal, 24)
//                .shadow(color: Color.mainColor.opacity(0.25), radius: 10, x: 0, y: 9)
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
                print(#fileID, #function, #line, "- 로그인 정보 있음")
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                appState.login(socialType: .kakao, socialId: token) // 로그인 completion 넘겨줌
            }
        }
    }
}

#Preview {
    LoginView()
}
