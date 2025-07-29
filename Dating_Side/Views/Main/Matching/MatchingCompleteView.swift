//
//  MatchingCompleteView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

/// 매칭 완성 뷰
struct MatchingCompleteView: View {
    @State private var showModal = false
    @State private var bottomSheetStartHeight: CGFloat = 0.45
   @State private var dragOffset: CGFloat = 0
    
    var profileContent: String = "당신은 안정적이며 의지할 수 있는 관계를 중요하게 생각합니다. 연애에서는 함께 시간을 보내는 것과 서로의 안정을 우선시하고, 공감하고 이해해주는 파트너를 선호합니다. 이전 연애에서는 아마도 깊은 유대감을 형성하려 했을 것이며, 앞으로도 의지할 수 있는 관계를 추구할 것으로 보입니다. 감정표현에서는 행동으로 마음을 전하는 경향이 있습니다. "
    var body: some View {
        ZStack(content: {
            VStack {
                Text("당신의 답장을 토대로\n프로필이 완성 되었어요")
                    .font(.pixel(20))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6)
                    .padding(.top, 50)
                Text("전체 프로필은 마이페이지에서 확인 하세요")
                    .font(.pixel(12))
                    .padding(.bottom, 65)
                Text(profileContent)
                    .font(.pixel(16))
                    .padding(.horizontal, 25.5)
                    .padding(.vertical, 50)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 38.5)
                Spacer()
                BottomSheet(showModal: $showModal, currentHeightRatio: $bottomSheetStartHeight)
                .sheet(isPresented: $showModal, onDismiss: {
                    bottomSheetStartHeight = 0.45
                }, content: {
                    OnChatProfileView(viewModel: ProfileViewModel())
                        .presentationDetents([.fraction(0.99)])
                        .presentationCornerRadius(10)
                        .presentationDragIndicator(.visible)
                })
            }
        })
//        .ignoresSafeArea(.container, edges: .bottom)
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
//                .ignoresSafeArea()
        )
    }
}

#Preview {
    MatchingCompleteView()
}
