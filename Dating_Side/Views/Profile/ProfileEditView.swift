//
//  ProfileEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/1/25.
//

import SwiftUI

struct ProfileEditView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var profileViewModel: ProfileViewModel
    var isOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ArrowNextRow(label: "닉네임 변경", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.nickname)
                } else {
                    appState.myPagePath.append(MyPage.nicknameInput(nickname: profileViewModel.userData?.nickName))
                }
            }
            ArrowNextRow(label: "프로필 사진, 자기소개", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.chatProfileImage)
                } else {
                    
                }
                
            }
            ArrowNextRow(label: "추가 사진 변경", subTitle: nil) {
                
                
            }
            ArrowNextRow(label: "지역 \(profileViewModel.userData?.activeRegion ?? "")", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.locationSelect)
                } else {
                    appState.myPagePath.append(MyPage.locationSelect(location: profileViewModel.userData?.activeRegion))
                }
            }
            ArrowNextRow(label: "학력 \(profileViewModel.userData?.educationDetail != "" ? profileViewModel.userData?.educationDetail ?? "" : profileViewModel.userData?.educationType ?? "")", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.editEducation)
                } else {
                    appState.myPagePath.append(MyPage.education(educationType: profileViewModel.userData?.educationType, schoolName: profileViewModel.userData?.educationDetail))
                }
                
            }
            ArrowNextRow(label: "직업 \(profileViewModel.userData?.jobDetail != "" ? profileViewModel.userData?.jobDetail ?? "" : profileViewModel.userData?.jobType ?? profileViewModel.userData?.jobType ?? "")", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.editJob)
                } else {
                    appState.myPagePath.append(MyPage.job(jobType: profileViewModel.userData?.jobType, jobDetail: profileViewModel.userData?.jobDetail))
                }
                
            }
            ArrowNextRow(label: "라이프 스타일", subTitle: "음주, 흡연, 타투, 종교") {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.susceptible)
                } else {
                    guard let lifestyle = profileViewModel.userData?.lifeStyle else { return }
                    appState.myPagePath.append(MyPage.susceptible(lifeStyle: lifestyle))
                }
            }
            ArrowNextRow(label: "러브심볼", subTitle: nil) {
                if isOnboarding {
//                    appState.onboardingPath.append(Onboarding.)
                } else {
                    guard let loveKeywords = profileViewModel.userData?.beforePreferenceTypeList else { return }
                    appState.myPagePath.append(MyPage.preferences(keywords: loveKeywords))
                }
            }
            Spacer()
        }
        .navigationTitle("프로필 편집")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }

    var saveButton: some View {
        Button(action: {
            
        }, label: {
            Text("저장")
                .font(.pixel(14))
                .foregroundStyle(Color.mainColor)
        })
    }

}

#Preview {
    ProfileEditView(isOnboarding: false)
}
