//
//  MathcingView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/01.
//

import SwiftUI

struct MathcingView: View {
    var category: String = "연애"
    var question: [String] = ["데이트날, 상대와 나의 꾸밈정도가 다르면 서운할 것 같으신가요?", "연락의 빈도가 연애에 큰 영향을 미친다고 생각하시나요?"]
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("오늘의 카테고리는\n\(category)")
                .font(.pixel(24))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 4)
            Text("질문 \(question.count)개에 답장하고\n운명의 상대를 매칭받으세요")
                .font(.pixel(16))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 48)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14, content: {
                    ForEach(question, id: \.self) { question in
                        makeQuestionCard(questionTitle: "질문1", question: question)
                    }
                })
            }
            .padding(.leading, 24)
            Spacer()
            answerQuestion
        }
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
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
        } label: {
            Text("답변하고 매칭받기")
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
    MathcingView()
}
