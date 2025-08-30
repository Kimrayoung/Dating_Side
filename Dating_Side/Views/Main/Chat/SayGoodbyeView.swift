//
//  SayGoodbyeView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/30/25.
//

import SwiftUI

struct SayGoodbyeView: View {
    @ObservedObject var viewModel: MatchingViewModel = MatchingViewModel()
    @State private var comment: String = ""
    @State private var score: Int = 0
    let scoreButtonWidth = (UIScreen.main.bounds.width - 48 - 32) / 5
    var body: some View {
        
        VStack {
            Text("상대에게 전하고 싶은 작별인사를 보내주세요.")
                .font(.pixel(16))
            Text("상대방은 몇점을 받았는지 알 수 없으니 안심하세요:)")
                .foregroundStyle(Color.gray2)
                .font(.pixel(12))
                .padding(.bottom, 20)
            HStack(spacing: 8) {
                veryGoodButton
                goodButton
                normalButton
                badButton
                veryBadButton
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 14)
            commentTextField
                .padding(.bottom, 24)
                .padding(.horizontal, 24)
            sendButton
                .padding(.bottom, 24)
        }
    }
    
    var veryGoodButton: some View {
        Button {
            score = 5
        } label: {
            scoreButtonLabel(text: "아주 좋아요", backgrounColor: .mainColor)
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var goodButton: some View {
        Button {
            score = 4
        } label: {
            scoreButtonLabel(text: "좋아요", backgrounColor: .subColor2)
                            
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var normalButton: some View {
        Button {
            score = 3
        } label: {
            scoreButtonLabel(text: "보통이에요", backgrounColor: .gray01)
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var badButton: some View {
        Button {
            score = 2
        } label: {
            scoreButtonLabel(text: "별로에요", backgrounColor: .gray2)
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var veryBadButton: some View {
        Button {
            score = 1
        } label: {
            scoreButtonLabel(text: "최악이에요", backgrounColor: .gray3)
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    
    
    func scoreButtonLabel(text: String, backgrounColor: Color) -> some View {
        return Text(text)
            .font(.pixel(12))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgrounColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var commentTextField: some View {
        TextField("더 좋은 인연 만나길 바라요", text: $comment)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.gray0)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var sendButton: some View {
        Button {
            Task {
                await viewModel.matchingCancel(score: score, comment: comment)
            }
        } label: {
            Text("전송하기")
                .font(.pixel(16))
                .foregroundStyle(Color.subColor)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 48)
        .background(Color.mainColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 24)
        .padding(.bottom, 109)
    }
}

#Preview {
    SayGoodbyeView()
}
