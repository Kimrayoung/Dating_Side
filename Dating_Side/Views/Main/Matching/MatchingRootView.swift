//
//  MatchingRootView.swift
//  Dating_Side
//
//  Created by 김라영 on 7/29/25.
//
import SwiftUI

struct MatchingRootView: View {
    @StateObject private var matchingViewModel = QuestionViewModel()
    
    var body: some View {
        QuestionListView()
            .environmentObject(matchingViewModel)
            .navigationDestination(for: Matching.self) { step in
                switch step {
                case .questionList:
                    QuestionListView()
                        .environmentObject(matchingViewModel)
                case .questionAnswer:
                    MatchingAnswerView()
                        .environmentObject(matchingViewModel)
                case .questionComplete:
                    MatchingCompleteView()
                        .environmentObject(matchingViewModel)
                case .matchingFail:
                    MatchingFailView()
                        .environmentObject(matchingViewModel)
                case .matchingSecondProfile:
                    SecondMathcingView()
                        .environmentObject(matchingViewModel)
                }
            }
    }
}
