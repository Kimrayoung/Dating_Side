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
    let socialType: SocialType
    let socialId: String
    
    var body: some View {
        NavigationStack(path: $appState.onboardingPath) {
            ChatProfileImageView(viewModel: viewModel)
//            GenderSelectView(viewModel: viewModel)
                .navigationDestination(for: Onboarding.self) { step in
                    switch step {
                    case .genderSelect: GenderSelectView(viewModel: viewModel)
                    case .nickname: NicknameInputView(viewModel: viewModel)
                    case .birth: BirthInputView(viewModel: viewModel)
                    case .height: HeightInputView(viewModel: viewModel)
                    case .locationSelect: LocationSelectView(viewModel: viewModel)
                    case .beforePreference: BeforePreferenceKewordSelectView(viewModel: viewModel)
                    case .afterPreference: AfterPreferenceKewordSelectView(viewModel: viewModel)
                    case .education: EducationSelectView(viewModel: viewModel)
                    case .schoolName: SchoolNameInput(viewModel: viewModel)
                    case .job: JobSelectView(viewModel: viewModel)
                    case .jobDetail: JobDetailInputView(viewModel: viewModel)
                    case .susceptible: SusceptibleInfoView(viewModel: viewModel)
                    case .chatProfileImage: ChatProfileImageView(viewModel: viewModel)
                    case .secondDayPhoto: ProfileSecondImageView(viewModel: viewModel)
                    case .forthDayPhoto: ProfileForthImageView(viewModel: viewModel)
                    case .sixthDayPhoto: ProfileSixthImageView(viewModel: viewModel)
                    }
                }
                .onAppear {
                    viewModel.socialType = socialType
                    viewModel.socialId = socialId
                }
        }
    }
}

