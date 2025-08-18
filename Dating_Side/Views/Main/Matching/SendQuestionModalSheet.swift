//
//  AddtionalQuestionSend.swift
//  Dating_Side
//
//  Created by 김라영 on 8/17/25.
//

import SwiftUI

struct SendQuestionModalSheet: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: QuestionViewModel
    @Binding var showQuestionModal: Bool
    @Binding var selectCategory: [Bool]
    @Binding var questionContent: String
    @Binding var sendQuestion: Bool
    
    var body: some View {
        VStack(content: {
            Text("카테고리 선택")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                makeValueProfileView(category: UserAnswerCategory.LOVE)
                makeValueProfileView(category: UserAnswerCategory.MARRIAGE)
                makeValueProfileView(category: UserAnswerCategory.WORK)
                makeValueProfileView(category: UserAnswerCategory.LIFE)
            }
            questionContentEditor
                .padding(.vertical, 16)
            // 질문 제출
            Button(action: {
                guard let selectedIndex = selectCategory.firstIndex(where: { $0 }) else { return }
                guard let selectedCategory = UserAnswerCategory(index: selectedIndex) else { return }
                let question = MyQuestion(category: selectedCategory.rawValue, question: questionContent)
                Task {
                    let result = await viewModel.postMyQuestion(question: question)
                    if result {
                        showQuestionModal = false
                        appState.matchingPath.append(Matching.matchingSecondProfile)
                    }
                }
            }, label: {
                SelectButtonLabel(isSelected: $sendQuestion, height: 48, text: "제출하기", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
        })
        .padding(.horizontal, 24)
    }
    
    func makeValueProfileView(category: UserAnswerCategory) -> some View {
        return Button(action: {
            for i in 0..<selectCategory.count {
                selectCategory[i] = i == category.index ? true : false
            }
        }, label: {
            ZStack {
                Text(category.korean)
                    .font(.pixel(12))
                    .foregroundStyle(Color.white)
                Image(category.imageString)
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .background(selectCategory[category.index] ? Color.mainColor : Color.init(hex: "#C6D4FB"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        })
    }
    
    var questionContentEditor: some View {
        VStack(content: {
            Text("상대에게 궁금한 질문")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $questionContent)
                .font(.pixel(12))
                .padding(8) // 내부 여백
                .background(Color.white) // 배경색 (필수: 테두리가 잘 보이게)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        })
        .frame(height: 165)
    }
}
