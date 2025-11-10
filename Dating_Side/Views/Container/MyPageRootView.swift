//
//  MyPageRootView.swift
//  Dating_Side
//
//  Created by 김라영 on 7/28/25.
//

import SwiftUI

struct MyPageRootView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        MyPageView()
            .environmentObject(profileViewModel)
            .navigationDestination(for: MyPage.self) { step in
                switch step {
                case .mypage:
                    MyPageView()
                        .environmentObject(profileViewModel)
                case .settingProfile(let userImageURL):
                    SettingAndEditView(userImageURL: userImageURL)
                        .environmentObject(profileViewModel)
                case .profileValueList(let valueType, let valueDataList):
                    ValuesListView(valueType: valueType, valueDataList: valueDataList)
                case .profileEdit:
                    ProfileEditView(userData: nil, isOnboarding: false)
                        .environmentObject(profileViewModel)
                case .account:
                    AccountView()
                case .introduceImageAndProfielMainImage:
                    ChatProfileImageView(viewModel: AccountViewModel(), viewType: .mypageEdit)
                case let .locationSelect(location):
                    LocationSelectView(viewModel: AccountViewModel(), location: location, viewType: .mypageEdit)
                case let .job(jobType, jobDetail):
                    JobEditView(viewModel: AccountViewModel(), jobType: jobType, jobDetail: jobDetail)
                case let .education(educationType, schoolName):
                    EducationEditView(viewModel: AccountViewModel(), educationType: educationType, schoolName: schoolName)
                case let .preferences(beforeKeywords, afterKeywords):
                    PreferenceKeywordsEditView(viewModel: AccountViewModel(), beforePreferences: beforeKeywords, afterPreferences: afterKeywords)
                case .susceptible(let lifeStyle):
                    SusceptibleInfoView(viewModel: AccountViewModel(), lifeStyle: lifeStyle)
                case .webView(let url):
                    WebView(urlString: url)
                case let .additionalImageEdit(profileImageUrls):
                    AdditionalImageEditView(isOnboarding: false, profileImageUrl: profileImageUrls)
                }
            }
    }
}
