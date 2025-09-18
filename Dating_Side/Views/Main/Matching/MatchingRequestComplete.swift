//
//  MatchingRequestComplete.swift
//  Dating_Side
//
//  Created by 김라영 on 9/12/25.
//

import SwiftUI

/// 대화하기를 요청하기 완료했을 경우
struct MatchingRequestComplete: View {
    @State private var showProfileView: Bool = false
    @ObservedObject var viewModel = MatchingViewModel()
    @State private var matchingProfile: PartnerAccount? = nil
    @State private var showModal = false
    @State private var bottomSheetStartHeight: CGFloat = 0.6
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("[\(matchingProfile?.nickName ?? "")] 님에게 대화를 요청했어요.\n상대가 수락하면 채팅이 시작됩니다!")
                .font(.pixel(20))
            Text("상대가 24시간 내 수락하지 않으면 대화요청이 종료됩니다.")
                .font(.pixel(12))
            if let matchingProfile = matchingProfile {
                ProfileMiniView(isDefault: false, userImageURL: matchingProfile.profileImageURL, userName: matchingProfile.nickName, userType: matchingProfile.keyword)
                    .clipShape(RoundedRectangle(cornerRadius: 8.85))
                    .frame(width: 180, height: 180)
                    .onTapGesture {
                        showProfileView.toggle()
                    }
            } else {
                ProfileMiniView(isDefault: false, userImageURL: nil, userName: "???", userType: "???")
                    .clipShape(RoundedRectangle(cornerRadius: 8.85))
                    .frame(width: 180, height: 180)
            }
            ProfileCheckBottomSheet(
                showModal: $showModal,
                currentHeightRatio: $bottomSheetStartHeight
            )
        }
        .sheet(isPresented: $showModal, onDismiss: {
            bottomSheetStartHeight = 0.6
        }) {
            PartnerProfileView(profileShow: $showModal, needMathcingRequest: .matching)
                .presentationDetents([.fraction(0.99)])
                .presentationCornerRadius(10)
                .presentationDragIndicator(.visible)
        }
        
    }
}

#Preview {
    MatchingRequestComplete()
}
