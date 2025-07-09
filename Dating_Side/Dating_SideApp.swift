//
//  Dating_SideApp.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/10.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct Dating_SideApp: App {
    @StateObject private var appState: AppState = AppState.shared
    
    init() {
        // Kakao SDK 초기화
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey:"\(kakaoAppKey)")
        }   
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onOpenURL { url in
                        if AuthApi.isKakaoTalkLoginUrl(url) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
        }
        
    }
}
