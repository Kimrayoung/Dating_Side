//
//  MatchingRootView.swift
//  Dating_Side
//
//  Created by 김라영 on 7/29/25.
//
import SwiftUI

struct MatchingRootView: View {
    @StateObject private var questionViewModel = QuestionViewModel()
    @State private var isLoading = true
    @State private var alreadyAnswer: Bool? = nil

    var body: some View {
        ZStack {
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if isLoading {
                ProgressView()
            } else if let alreadyAnswer {
                if !alreadyAnswer {
                    MatchingQuestionListView()
                } else {
                    AnswerCompleteMainView()
                }
            } else {
                // 네트워크 실패 등 예외 처리 (선택)
                Text("불러오기에 실패했어요. 다시 시도해주세요.")
            }
        }
        .task {
            isLoading = true
            let result = await questionViewModel.checkingTodayQuestionAnswer()
            await MainActor.run {
                alreadyAnswer = result
                isLoading = false
            }
        }
        .environmentObject(questionViewModel)
        .navigationDestination(for: Matching.self) { step in
            switch step {
            ///오늘의 질문 리스트 확인
            case .questionList:
                MatchingQuestionListView()
                    .environmentObject(questionViewModel)
            /// 답변하고 매칭받기
            case .questionAnswer:
                MatchingAnswerView()
                    .environmentObject(questionViewModel)
            ///질문 보내기 완료
            case .questionComplete:
                MatchingAnswerCompleteView()
                    .environmentObject(questionViewModel)
            case .matchingFail:
                MatchingFailView()
                    .environmentObject(questionViewModel)
            case .matchingSecondProfile:
                SecondMathcingView()
                    .environmentObject(questionViewModel)
            case .answerCompleteMain:
                AnswerCompleteMainView()
                    .environmentObject(questionViewModel)
            case .matchingProfileCheckView:
                MatchingProfileCheckView()
                    .environmentObject(questionViewModel)
            }
        }
    }
}
