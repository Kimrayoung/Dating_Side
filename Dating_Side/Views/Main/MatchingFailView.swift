//
//  MatchingFailView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

struct MatchingFailView: View {
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
            ProfileMiniView(isDefault: true, userImageURL: nil  )
                .clipShape(RoundedRectangle(cornerRadius: 8.85))
                .frame(width: 180, height: 180)
            Spacer()
            btnStack
        }
        .sheet(isPresented: $showQuestionModal, content: {
            sendQuestionModalSheet
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
    
    var sendQuestionModalSheet: some View {
        VStack(content: {
            Text("카테고리 선택")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                makeValueProfileView(imageString: "loveView", text: "연애", num: 0)
                makeValueProfileView(imageString: "marryView", text: "결혼", num: 1)
                makeValueProfileView(imageString: "workView", text: "직장", num: 2)
                makeValueProfileView(imageString: "lifeView", text: "생활", num: 3)
            }
            questionContentEditor
            Button(action: {
                
            }, label: {
                SelectButtonLabel(isSelected: $sendQuestion, height: 42, text: "제출하기", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
        })
        .padding(.horizontal, 24)
    }
    
    func makeValueProfileView(imageString: String, text: String, num: Int) -> some View {
        return Button(action: {
            for i in 0..<selectCategory.count {
                selectCategory[i] = i == num ? true : false
            }
        }, label: {
            ZStack {
                Text(text)
                    .font(.pixel(12))
                    .foregroundStyle(Color.white)
                Image(imageString)
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .background(selectCategory[num] ? Color.mainColor : Color.init(hex: "#C6D4FB"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        })
    }
    
    var questionContentEditor: some View {
        VStack(content: {
            Text("상대에게 궁금한 점")
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

#Preview {
    MatchingFailView()
}
