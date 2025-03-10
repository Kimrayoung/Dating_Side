//
//  ContentView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/10.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Group {
            switch appState.currentScreen {
            case .onboarding:
                OnboardingContainerView()
            case .login:
                LoginView()
            case .main:
                MainContainerView()
            }
        }
    }
}
