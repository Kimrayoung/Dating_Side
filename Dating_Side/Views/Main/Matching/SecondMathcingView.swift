//
//  SecondMathcingView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

struct SecondMathcingView: View {
    @State private var showProfileView: Bool = false
    @ObservedObject var viewModel = MatchingViewModel()
    @State private var matchingProfile: PartnerAccount? = nil
    
    var body: some View {
        VStack(content: {
            Text("질문 주셔서 감사합니다.\n당신에게 딱 맞는 두번쨰 상대입니다.")
                .multilineTextAlignment(.center)
                .font(.pixel(20))
                .foregroundStyle(Color.whiteColor)
                .padding(.top, 20)
                .padding(.bottom, 6)
            Spacer()
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
            Spacer()
        })
        .task {
            matchingProfile = await viewModel.matchingRequest()
        }
        .sheet(isPresented: $showProfileView, content: {
            PartnerProfileView(profileShow: $showProfileView, needMathcingRequest: .matching, matchingPartnerTempAccount: matchingProfile)
                .presentationDetents([.fraction(0.99)])
                .presentationCornerRadius(10)
                .presentationDragIndicator(.visible)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SecondMathcingView()
}
