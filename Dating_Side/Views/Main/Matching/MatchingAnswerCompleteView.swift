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
    @State private var bottomSheetStartHeight: CGFloat = 0.6
    @State private var dragOffset: CGFloat = 0
    
    @State var profileContent: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경 이미지
                Image("matchingViewBg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("당신의 답장을 토대로\n프로필이 완성 되었어요")
                            .font(.pixel(20))
                            .multilineTextAlignment(.center)
                        
                        Text("전체 프로필은 마이페이지에서 확인 하세요")
                            .font(.pixel(12))
                    }
                    .padding(.top, 120)
                    .padding(.bottom, 65)
                    .frame(alignment: .center)
                    
                    ScrollView {
                        Text(profileContent)
                            .font(.pixel(16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 25.5)
                            .padding(.vertical, 25)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 316, height: 329)
                    .padding(.horizontal, 38.5)
                    
                    // 하단 버튼 영역
                    ProfileCheckBottomSheet(
                        showModal: $showModal,
                        currentHeightRatio: $bottomSheetStartHeight
                    )
                }
            }
        }
        .sheet(isPresented: $showModal, onDismiss: {
            bottomSheetStartHeight = 0.6
        }) {
            PartnerProfileView(profileShow: $showModal, needMathcingRequest: .matching)
                .presentationDetents([.fraction(0.99)])
                .presentationCornerRadius(10)
                .presentationDragIndicator(.visible)
        }
//        .task {
//            let checkingTodayQuestionAnswer = await questionViewModel.checkingTodayQuestionAnswer()
//            if !checkingTodayQuestionAnswer {
//                profileContent = await questionViewModel.postTodayQuetionAnswers()
//            } else {
//                profileContent = questionViewModel.todayQuestionAnswer
//            }
//        }
    }
    
    private func goToMatchingFailView() {
        appState.matchingPath.append(Matching.matchingFail)
    }
}

#Preview {
    MatchingAnswerCompleteView(viewModel: MatchingViewModel())
}
