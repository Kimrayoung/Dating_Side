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
    var userData: ProfileEditUserAccount?
    var isOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ArrowNextRow(label: "프로필 사진, 자기소개", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.chatProfileImage)
                } else {
                    appState.myPagePath.append(MyPage.introduceImageAndProfielMainImage)
                }
                
            }
            ArrowNextRow(label: "추가 사진 변경", subTitle: nil) {
                if isOnboarding {
                    
                } else {
                    appState.myPagePath.append(MyPage.additionalImageEdit(profileImageUrl: profileViewModel.userData?.profileImageURLByDay))
                }
                
            }
            ArrowNextRow(label: "지역 변경", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.locationSelect)
                } else {
                    appState.myPagePath.append(MyPage.locationSelect(location: profileViewModel.userData?.activeRegion))
                }
            }
            ArrowNextRow(label: "학력 변경", subTitle: nil) {
                if isOnboarding {
                    appState.onboardingPath.append(Onboarding.editEducation)
                } else {
                    appState.myPagePath.append(MyPage.education(educationType: profileViewModel.userData?.educationType, schoolName: profileViewModel.userData?.educationDetail))
                }
                
            }
            ArrowNextRow(label: "직업 변경", subTitle: nil) {
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
                    appState.onboardingPath.append(Onboarding.editPreference)
                } else {
                    guard let beforeLoveKeywords = profileViewModel.userData?.beforePreferenceTypeList, let afterLoveKeywords = profileViewModel.userData?.afterPreferenceTypeList else { return }
                    
                    appState.myPagePath.append(MyPage.preferences(beforeKeywords: beforeLoveKeywords, afterKeywords: afterLoveKeywords))
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
                    if isOnboarding {
                        appState.onboardingPath.removeLast()
                    } else {
                        appState.myPagePath.removeLast()
                    }
                    
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
