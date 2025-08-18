//
//  OnboardingCompleteView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/3/25.
//

import SwiftUI

struct OnboardingCompleteView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileView(simpleProfile: "\(viewModel.nicknameInput)/\(viewModel.birthYear.joined())/1\(viewModel.makeHeight())cm", educationString: "\(viewModel.makeEducationType()?.korean ?? "")\(viewModel.schoolName != "" ? "," : "") \(viewModel.schoolName)", jobString: "\(viewModel.makeJobType()?.korean ?? "")\(viewModel.jobDetail != "" ? "," : "") \(viewModel.jobDetail)", location: viewModel.makeLocation(), lifeStyle: viewModel.makeLifeStyle(needKorean: true), valueList: [:], onboardingDefaultImageData: viewModel.selectedImage, introduceText: viewModel.introduceText, showProfileViewType: .onboarding)
                photoView
                    .padding(.bottom, 20)
                HStack {
                    editProfileButton
                    completeProfileButton
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear(perform: {
            viewModel.isOnboarding = .onboardingEdit
        })
        .navigationTitle("프로필")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        
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
                let images = [viewModel.selectedSeconDayImage, viewModel.selectedForthDayImage, viewModel.selectedSixthDayImage]
                ForEach(images, id: \.self) { imageData in
                    if let imageData = imageData {
                        Image(uiImage: imageData)
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
            } //HStack
        } //ScrollView
    }
    
    var editProfileButton: some View {
        Button {
            guard let userAccount = viewModel.makeOnboardingCompleteData() else { return }
            appState.onboardingPath.append(Onboarding.profileEdit(userData: userAccount))
        } label: {
            Text("프로필 편집")
                .font(.pixel(16))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray0)
                )
        }
    }
    
    var completeProfileButton: some View {
        Button {
            Task {
                await viewModel.postUserData()
            }
        } label: {
            Text("확인 완료")
                .font(.pixel(16))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.mainColor)
                )
        }
    }
    
}

#Preview {
    OnboardingCompleteView(viewModel: AccountViewModel())
}
