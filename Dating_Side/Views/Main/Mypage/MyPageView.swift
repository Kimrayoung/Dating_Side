//
//  SettingView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI
import Kingfisher

@MainActor
struct MyPageView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileView(simpleProfile: profileViewModel.makeSimpleProfile(userData: profileViewModel.userData), educationString: profileViewModel.makeSchoolString(userData: profileViewModel.userData), jobString: profileViewModel.makeJobString(userData: profileViewModel.userData), location: profileViewModel.userData?.activeRegion ?? "", lifeStyle: profileViewModel.userData?.lifeStyle, keyword: profileViewModel.userData?.keyword, valueList: profileViewModel.userValueList, defaultImageUrl: profileViewModel.userData?.profileImageURL, introduceText: profileViewModel.userData?.introduction, showProfileViewType: .myPage)
                photoView
            }
        }
        .task {
            await profileViewModel.fetchUserAccountData()
            await profileViewModel.fetchUserAnswerList()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.myPagePath.append(MyPage.settingProfile(userImageURL: profileViewModel.userData?.profileImageURL))
                } label: {
                    Image("myPageToast")
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Text("마이페이지")
                    .font(.pixel(20))
                    .fixedSize(horizontal: true, vertical: false)
            }
        })
    }
    
    var photoView: some View {
        VStack {
            Text("내 사진첩")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            myPhoto
        }
        .padding(.leading, 24)
    }
    
    var myPhoto: some View {
        ScrollView(.horizontal) {
            HStack {
                if let imageObj = profileViewModel.userData?.profileImageURLByDay {
                    let images = [imageObj.daySecond, imageObj.dayFourth, imageObj.daySixth]
                    ForEach(images, id: \.self) { imageUrl in
                        if let url = URL(string: imageUrl) {
                            KFImage(url)
                                .resizable()
                                .frame(width: 240, height: 360)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Image("checkerImage")
                                .resizable()
                                .frame(width: 240, height: 360)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                } //if let
            } //HStack
        } //ScrollView
    }
    
}

#Preview {
    MyPageView()
}
