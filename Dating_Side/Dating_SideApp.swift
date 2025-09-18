//
//  Dating_SideApp.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/10.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import NidThirdPartyLogin
import Lottie

@main
struct Dating_SideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState: AppState = AppState.shared
    @StateObject private var loadingManager = LoadingManager.shared
    @StateObject private var alertManager = AlertManager.shared
    
    init() {
        // Kakao SDK 초기화
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey:"\(kakaoAppKey)")
        }
        NidOAuth.shared.initialize()
        Task {
            await MatchingGlobalViewModel().fetchMatchingStauts()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(appState)
                    .environmentObject(loadingManager)
                    .onOpenURL { url in
                        handleOpenURL(url)
                    }
                    .customAlert(
                        isPresented: $alertManager.isPresented,
                        title: alertManager.title,
                        message: alertManager.message,
                        primaryButtonText: alertManager.primaryButtonText,
                        primaryButtonAction: alertManager.primaryButtonAction,
                        primaryButtonColor: alertManager.primaryButtonColor,
                        secondaryButtonText: alertManager.secondaryButtonText,
                        secondaryButtonAction: alertManager.secondaryButtonAction,
                        secondaryButtonColor: alertManager.secondaryButtonColor
                    )

                if loadingManager.isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    LoadingView()
                        .frame(width: 150, height: 150)
                }
            }
        }
    }
    
    // URL 처리를 하나의 함수로 통합
    private func handleOpenURL(_ url: URL) {
        // 네이버 로그인 URL 처리
        if NidOAuth.shared.handleURL(url) {
            print("네이버 로그인 URL 처리됨")
            return
        }
        
        // 카카오 로그인 URL 처리
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
            print("카카오 로그인 URL 처리됨")
            return
        }
        
        // 기타 URL 처리
        print("처리되지 않은 URL: \(url)")
    }
}
