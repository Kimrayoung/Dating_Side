//
//  MatchingFailView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

/// 매칭 실패시 뷰(매칭 끝내기 or 질문 보내기 선택 뷰) -> 질문보내고 두번째 매칭 받던가
struct MatchingFailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: QuestionViewModel
    @State private var showQuestionModal: Bool = false
    @State private var selectCategory: [Bool] = [true, false, false, false]
    @State private var questionContent: String = ""
    @State private var sendQuestion: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("아쉽네요.\n러브웨이에서 사용할 질문을 보내 주면\n프로필을 한번 더 드려요")
                .multilineTextAlignment(.center)
                .font(.pixel(20))
                .foregroundStyle(Color.whiteColor)
                .padding(.top, 20)
                .padding(.bottom, 6)
            Text("사람들에게 사용할 질문에 반영 돼요")
                .font(.pixel(12))
                .foregroundStyle(Color.whiteColor)
            Spacer()
            ProfileMiniView(isDefault: true, userImageURL: nil)
                .clipShape(RoundedRectangle(cornerRadius: 8.85))
                .frame(width: 180, height: 180)
            Spacer()
            btnStack
        }
        .sheet(isPresented: $showQuestionModal, content: {
            SendQuestionModalSheet(viewModel: viewModel, showQuestionModal: $showQuestionModal, selectCategory: $selectCategory, questionContent: $questionContent, sendQuestion: $sendQuestion)
//                .presentationDetents([.fraction(0.99)])
                .presentationDetents([.medium])
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
    
    var btnStack: some View {
        VStack(content: {
            sendQuestionBtn
            finishMatching
        })
        .padding(.bottom, 60)
        .padding(.horizontal, 24)
    }
    
    var sendQuestionBtn: some View {
        Button(action: {
            showQuestionModal.toggle()
        }, label: {
            Text("질문 보내주기")
                .font(.pixel(16))
                .foregroundStyle(Color.mainColor)
        })
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.whiteColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var finishMatching: some View {
        Button(action: {
            /// 답변완료시 메인화면으로 이동
            appState.myPagePath.append(Matching.answerCompleteMain)
        }, label: {
            Text("매칭 끝내기")
                .font(.pixel(16))
                .foregroundStyle(Color.whiteColor)
        })
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.mainColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    
    
    
    
    
}

#Preview {
    MatchingFailView()
}
