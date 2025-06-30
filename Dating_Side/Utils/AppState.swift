//
//  AppState.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

// 앱 상태를 관리하는 클래스
class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var currentScreen: AppScreen
    @Published var isFirstLaunch: Bool
    @Published var isLoggedIn: Bool
    @Published var mainPath = NavigationPath()
    @Published var onboardingPath = NavigationPath()
    @Published var loginPath = NavigationPath()

    
    init() {
        // UserDefaults에서 첫 실행 여부 확인
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        self.isFirstLaunch = isFirstLaunch
        
        // UserDefaults에서 로그인 상태 확인
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.isLoggedIn = isLoggedIn
        
        // 첫 실행이면 온보딩, 로그인되어 있으면 메인, 아니면 로그인 화면
//        if isFirstLaunch {
//            currentScreen = .onboarding
//        } else if isLoggedIn {
//            currentScreen = .main
//        } else {
//            currentScreen = .login
//        }
//        currentScreen = .onboarding
        currentScreen = .main
    }
    
    func startOnboarding() {
        onboardingPath = NavigationPath()
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        
        // 사용자 정보 저장
//        UserDefaults.standard.set(userNickname, forKey: "userNickname")
//        UserDefaults.standard.set(userAge, forKey: "userAge")
//        UserDefaults.standard.set(userHeight, forKey: "userHeight")
//        UserDefaults.standard.set(userStyle, forKey: "userStyle")
        
        currentScreen = .login
    }
    
    func login() {
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        currentScreen = .onboarding
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        currentScreen = .login
    }
}
