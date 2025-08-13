//
//  MatchingRootView.swift
//  Dating_Side
//
//  Created by 김라영 on 7/29/25.
//
import SwiftUI

struct MatchingRootView: View {
    @StateObject private var questionViewModel = QuestionViewModel()
    
    var body: some View {
         MatchingQuestionListView()
            .environmentObject(questionViewModel)
            .navigationDestination(for: Matching.self) { step in
                switch step {
                case .questionList:
                     MatchingQuestionListView()
                        .environmentObject(questionViewModel)
                case .questionAnswer:
                    MatchingAnswerView()
                        .environmentObject(questionViewModel)
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
                }
            }
    }
}
