//
//  LoginCotainerView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/17.
//

import SwiftUI

struct LoginCotainerView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack(path: $appState.loginPath) {
            PhoneNumberView(viewModel: viewModel)
                .navigationDestination(for: Login.self) { step in
                    switch step {
                    case .phoneNumber: PhoneNumberView(viewModel: viewModel)
                    case .verificationNumber:
                        VerificationNumber(viewModel: viewModel)
                    }
                }
        }
    }
}
