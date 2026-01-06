//
//  MathcingView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/01.
//

import SwiftUI

/// 매칭을 받기 위한 오늘의 질문 확인 뷰
struct  MatchingQuestionListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: QuestionViewModel
    @AppStorage("matchingStatus") private var matchingStatusRaw: String = MatchingStatusType.UNMATCHED.rawValue
    
    private var matchingStatus: MatchingStatusType {
        get { MatchingStatusType(rawValue: matchingStatusRaw) ?? .UNMATCHED }
        set { matchingStatusRaw = newValue.rawValue }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("오늘의 카테고리는\n\(viewModel.category)")
                .font(.pixel(24))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 4)
            Text("질문 \(viewModel.questionList.count)개에 답장하고\n운명의 상대를 매칭받으세요")
                .font(.pixel(16))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 48)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14, content: {
                    ForEach(viewModel.questionList, id: \.self) { question in
                        makeQuestionCard(questionTitle: "질문 \(question.id)", question: question.text)
                    }
                })
            }
            .padding(.leading, 24)
            .padding(.bottom, 56)
            answerQuestion
            
        }
        .task {
            await viewModel.fetchTodayQuestions()
        }
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.container, edges: .top) // .bottom 대신 .top만!
        )
    }
    
    func makeQuestionCard(questionTitle: String, question: String) -> some View {
        return VStack {
            Text(questionTitle)
                .font(.pixel(12))
                .foregroundStyle(Color.white)
            Spacer()
            Text(question)
                .font(.pixel(16))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding() // 내부 여백
        .frame(width: 222, height: 330)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.mainColor).opacity(0.25) // 배경색 지정
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 1).opacity(0.5) // 테두리 색과 두께
        )
    }
    
    var answerQuestion: some View {
        Button {
            print(#fileID, #function, #line, "- 답변화면으로 이동")
            appState.matchingPath.append(Matching.questionAnswer)
        } label: {
            Text(matchingStatus == .MATCHED ? "답변하기" : "답변하고 매칭받기")
                .font(.pixel(16))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 345, height: 48)
        .background(Color.init(hex: "#8494F6"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
     MatchingQuestionListView()
}
