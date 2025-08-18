//
//  AnswerCompleteMainView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/11/25.
//

import SwiftUI
/// 답변완료시 메인 화면

struct AnswerCompleteMainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject private var viewModel: QuestionViewModel
    @State private var alreadySendTodayQuestion: Bool = false
    @State private var showQuestionModal: Bool = false
    @State private var selectCategory: [Bool] = [true, false, false, false]
    @State private var questionContent: String = ""
    @State private var sendQuestion: Bool = false
    @State private var showToastPopup: Bool = false
    
    var body: some View {
        VStack {
            Text("당신의 답변을 토대로\n오늘의 카드가 완성 되었어요")
                .multilineTextAlignment(.center)
                .font(.pixel(20))
                .padding(.top, 50)
            Text("전체 카드는 마이페이지에서 확인 하세요")
                .font(.pixel(12))
            ScrollView {
                VStack {
                    Text("[\(viewModel.category)]")
                        .font(.pixel(12))
                        .padding(.bottom, 16)
                    Text(viewModel.todayQuestionAnswer)
                        .font(.pixel(16))
                        
                }
            }
            .frame(height: 330)
            .padding(.horizontal, 38.5)
            .padding(.vertical, 15)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .background(
                LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(hex: "#FDFDFF").opacity(0.1), location: 0.0),   // 0%
                            .init(color: Color(hex: "#FFFFFF").opacity(0.2), location: 0.51),  // 51%
                            .init(color: Color(hex: "#FFFFFF").opacity(0.6), location: 1.0)    // 100%
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
            )
            .overlay( // 그라데이션 보더
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.white.opacity(0.0), location: 0.0),  // 0%
                                .init(color: Color.white.opacity(0.2), location: 0.51), // 51%
                                .init(color: Color.white.opacity(0.5), location: 1.0)   // 100%
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 49)
            .padding(.top, 51)
            sendQuestionBtn
                .padding(.top, 43)
                .padding(.bottom, 12)
            confirmPartner
                .padding(.bottom, 44)
        }
        .customToastPopup(isPresented: $showToastPopup, title: "오늘은 이미 질문을 작성했어요", message: "")
        .sheet(isPresented: $showQuestionModal, content: {
            SendQuestionModalSheet(viewModel: viewModel, showQuestionModal: $showQuestionModal, selectCategory: $selectCategory, questionContent: $questionContent, sendQuestion: $sendQuestion)
//                .presentationDetents([.fraction(0.99)])
                .presentationDetents([.medium])
                .presentationCornerRadius(10)
                .presentationDragIndicator(.visible)
        })
        .ignoresSafeArea(.container, edges: .bottom)
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    var sendQuestionBtn: some View {
        Button {
            Task {
                alreadySendTodayQuestion = await viewModel.alreadySendTodayQuestion()
                if alreadySendTodayQuestion {
                    showToastPopup = true
                } else {
                    showQuestionModal.toggle()
                }
            }
        } label: {
            Text("질문 보내주기")
                .font(.pixel(16))
                .foregroundStyle(Color.mainColor)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 48)
        .background(Color.subColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 25.5)
    }
    
    var confirmPartner: some View {
        Button {
            appState.matchingPath.append(Matching.matchingProfileCheckView)
        } label: {
            Text("매칭 상대 확인하기")
                .font(.pixel(16))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 48)
        .background(Color.mainColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 25.5)
    }
}

#Preview {
    AnswerCompleteMainView()
}
