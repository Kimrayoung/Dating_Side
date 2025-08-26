//
//  MatchingAnswerCompleteView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

/// 프로필 완성 뷰(오늘의 질문 답변 완료시 -> 매칭 프로필 확인 및 답변을 통한 카드완성)
struct MatchingAnswerCompleteView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject var questionViewModel: QuestionViewModel
    @ObservedObject var viewModel: MatchingViewModel = MatchingViewModel()
    @State private var showModal = false
    @State private var bottomSheetStartHeight: CGFloat = 0.45
    @State private var dragOffset: CGFloat = 0
    
    @State var profileContent: String = ""
    
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
                ProfileCheckBottomSheet(showModal: $showModal, currentHeightRatio: $bottomSheetStartHeight)
                    .sheet(isPresented: $showModal, onDismiss: {
                        bottomSheetStartHeight = 0.5
                    }, content: {
                        // 내 프로필을 통해서 매칭 상대를 찾아야 하므로 needMatchingRequest가 true
                        PartnerProfileView(profileShow: $showModal, needMathcingRequest: .matching)
                            .presentationDetents([.fraction(0.99)])
                            .presentationCornerRadius(10)
                            .presentationDragIndicator(.visible)
                    })
            }
        })
        .task {
            profileContent = await questionViewModel.postTodayQuetionAnswers()
//            _ = await viewModel.matchingRequest()
        }
//                .ignoresSafeArea(.container, edges: .bottom)
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    private func goToMatchingFailView() {
        appState.matchingPath.append(Matching.matchingFail)
    }
}

#Preview {
    MatchingAnswerCompleteView(viewModel: MatchingViewModel())
}
