//
//  OnboardingContainerView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack(path: $appState.onboardingPath) {
            GenderSelectView(viewModel: viewModel)
                .navigationDestination(for: Onboarding.self) { step in
                    switch step {
                    case .genderSelect: GenderSelectView(viewModel: viewModel)
                    case .locationSelect: LocationSelectView(viewModel: viewModel)
                    case .loveKeyword, .keyword: LoveKeywordSelectView(viewModel: viewModel)
                    case .userProfile: UserProfileInputView(viewModel: viewModel)
                    case .education: EducationSelectView(viewModel: viewModel)
                    }
                }
        }
    }
}

