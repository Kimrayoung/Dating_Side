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
        KakaoSDK.initSDK(appKey:"[네이티브 앱 키]")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
