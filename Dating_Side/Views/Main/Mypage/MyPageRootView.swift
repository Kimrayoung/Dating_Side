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
                    ProfileEditView()
                case .account:
                    AccountView()
                }
            }
    }
}
