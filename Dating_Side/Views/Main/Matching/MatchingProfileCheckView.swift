//
//  MatchingProfileCheckView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/17/25.
//

import SwiftUI

/// 매칭된 프로필 확인 뷰
struct MatchingProfileCheckView: View {
    @ObservedObject var viewModel = MatchingViewModel()
    @State private var matchingProfile: PartnerAccount? = nil
    @State private var showModal = false
    @State private var bottomSheetStartHeight: CGFloat = 0.45
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            if let matchingProfile = matchingProfile {
                Text("러브웨이가 당신과 결이 맞는 상태를\n찾아왔어요!")
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .font(.pixel(20))
                Text("프로필을 확인하고 상대의 매력을 확인해보세요.")
                    .foregroundStyle(Color.white)
                    .font(.pixel(20))
                    .padding(.bottom, 126)
                ProfileMiniView(isDefault: false, userImageURL: matchingProfile.profileImageURL, userName: matchingProfile.nickName, userType: matchingProfile.keyword)
                    .clipShape(RoundedRectangle(cornerRadius: 8.85))
                    .frame(width: 180, height: 180)
                Spacer()
                ProfileCheckBottomSheet(showModal: $showModal, currentHeightRatio: $bottomSheetStartHeight)
                    .sheet(isPresented: $showModal, onDismiss: {
                        bottomSheetStartHeight = 0.5
                    }, content: {
                        // 내 프로필을 통해서 매칭 상대를 찾음
                        PartnerProfileView(profileShow: $showModal, needMathcingRequest: true)
                            .presentationDetents([.fraction(0.99)])
                            .presentationCornerRadius(10)
                            .presentationDragIndicator(.visible)
                    })
            } else {
                Text("아직 유저가 많지 않아 상대를\n찾지 못했어요")
                    .multilineTextAlignment(.center)
                    .font(.pixel(20))
                    .foregroundStyle(Color.white)
                Text("상대가 매칭 될 떄 까지 프로필 받기 버튼을 눌러주세요.\n 운영자) 빠르게 성장할 수 있게 러브웨이를 응원해주세요.")
                    .multilineTextAlignment(.center)
                    .font(.pixel(12))
                    .foregroundStyle(Color.white)
                Spacer()
                ProfileMiniView(isDefault: false, userImageURL: nil, userName: "???", userType: "???")
                    .clipShape(RoundedRectangle(cornerRadius: 8.85))
                    .frame(width: 180, height: 180)
                Spacer()
                tryMatchingBtn
            }
        }
        .task {
            matchingProfile = await viewModel.matchingPartner()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    var tryMatchingBtn: some View {
        Button {
            Task {
                matchingProfile = await viewModel.matchingRequest()
            }
        } label: {
            Text("프로필 받기")
                .font(.pixel(16))
                .foregroundStyle(Color.subColor)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 48)
        .background(Color.mainColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 25.5)
        .padding(.bottom, 109)
    }
}

#Preview {
    MatchingProfileCheckView()
}
