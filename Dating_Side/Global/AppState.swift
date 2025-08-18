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
    let loadingManager = LoadingManager.shared
    let accountNetworkManger = AccountNetworkManager()
    
    @Published var currentScreen: AppScreen
    @Published var isFirstLaunch: Bool
    @Published var isLoggedIn: Bool
    @Published var chatPath = NavigationPath()
    @Published var matchingPath = NavigationPath()
    @Published var myPagePath = NavigationPath()
    @Published var onboardingPath = NavigationPath()
    @Published var onChatProfilePath = NavigationPath()

    init() {
        // UserDefaults에서 첫 실행 여부 확인
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        self.isFirstLaunch = isFirstLaunch
        
        // UserDefaults에서 로그인 상태 확인
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.isLoggedIn = isLoggedIn
        Log.debugPublic("첫 실행확인 여부: ", isFirstLaunch)
        Log.debugPublic("로그인 상태: ", isLoggedIn)
        // 첫 실행이면 온보딩, 로그인되어 있으면 메인, 아니면 로그인 화면
        if isLoggedIn {
            currentScreen = .main
        } else {
            currentScreen = .login
        }
    }
    
    func startOnboarding() {
        onboardingPath = NavigationPath()
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        
        currentScreen = .login
    }
    
    /// 로그인 시도
    @MainActor
    func login(socialType: SocialType, token: String) {
        Task {
            loadingManager.isLoading = true
            defer {
                loadingManager.isLoading = false
            }
            Log.debugPublic("로그인 시도")
            do {
                let loginRequest = LoginRequest(socialType: socialType.rawValue, socialAccessToken: token)
                let result = try await accountNetworkManger.login(userSocialId: loginRequest)
                switch result {
                case .success:
                    Log.infoPrivate("로그인 성공", socialType, token)
                    onAuthenticated()
                case .failure(let error):
                    if case let APIError.serverError(code) = error {
                        Log.infoPrivate("서버 에러 발생🔥: \(code)", token)
                        AlertManager.shared.serverAlert()
                    } else {
                        Log.infoPrivate("로그인 실패🔥: \(error.localizedDescription)", token)
                        currentScreen = .onboarding(socialType, token)
                    }
                }
            } catch {
                Log.infoPrivate("로그인 중 에러 발생🔥: \(error.localizedDescription)", token)
            }
        }
    }
    
    @MainActor
    func logout() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        do {
            let result = try await accountNetworkManger.logout()
            
            switch result {
            case .success:
                offAuthenticated()
                
            case .failure(let error):
                Log.errorPublic("logout error", error.localizedDescription)
            }
        } catch {
            Log.errorPublic("logout error", error.localizedDescription)
        }
    }
    
    /// 계정탈퇴
    @MainActor
    func accountDelete() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        do {
            let result = try await accountNetworkManger.deleteAccount()
            
            switch result {
            case .success:
                offAuthenticated()
            case .failure(let error):
                Log.errorPublic("account Delete error", error.localizedDescription)
            }
        } catch {
            Log.errorPublic("account Delete error", error.localizedDescription)
        }
    }
    
    /// 앱 초기화
    func offAuthenticated() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        chatPath = NavigationPath()
        matchingPath = NavigationPath()
        myPagePath = NavigationPath()
        currentScreen = .login
    }
    
    func onAuthenticated() {
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        currentScreen = .main
        onboardingPath = NavigationPath()
        let accessToken = KeychainManager.shared.getAccessToken()
        Log.debugPrivate("accessToken checking", accessToken)
    }
}
