//
//  SayGoodbyeView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/30/25.
//

import SwiftUI

struct SayGoodbyeView: View {
    
    @State private var comment: String = ""
    @State private var score: Int = 0
    
    var onSend: (Int, String) async -> Void?
    
    let scoreButtonWidth = (UIScreen.main.bounds.width - 48 - 32) / 5
    
    var body: some View {
        
        VStack {
            Text("상대에게 전하고 싶은 작별인사를 보내주세요.")
                .font(.pixel(16))
                .padding(.top, 30)
            
            Text("상대에게는 메시지만 표시됩니다.")
                .foregroundStyle(Color.gray2)
                .font(.rounded(14))
                .padding(.bottom, 4)
                .padding(.top, 4)
            
            HStack(spacing: 8) {
                veryGoodButton
                goodButton
                normalButton
                badButton
                veryBadButton
            }
            .padding(.bottom, 24)
            .buttonStyle(.plain)
            
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
            scoreButtonLabel(
                text: "아주 좋아요",
                backgrounColor: score == 5 ? .mainColor : .gray01
            )
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var goodButton: some View {
        Button {
            score = 4
        } label: {
            scoreButtonLabel(
                text: "좋아요",
                backgrounColor: score == 4 ? .mainColor : .gray01
            )
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var normalButton: some View {
        Button {
            score = 3
        } label: {
            scoreButtonLabel(
                text: "보통이에요",
                backgrounColor: score == 3 ? .mainColor : .gray01
            )
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var badButton: some View {
        Button {
            score = 2
        } label: {
            scoreButtonLabel(
                text: "별로에요",
                backgrounColor: score == 2 ? .mainColor : .gray01
            )
        }
        .frame(width: scoreButtonWidth, height: 36)
    }
    
    var veryBadButton: some View {
        Button {
            score = 1
        } label: {
            scoreButtonLabel(
                text: "최악이에요",
                backgrounColor: score == 1 ? .mainColor : .gray01
            )
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
                await onSend(score, comment)
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
    }
}

#Preview {
    SayGoodbyeView(onSend: { score, comment in
        // 버튼을 누르면 이 코드가 실행됩니다.
        print("---------- 전송 시뮬레이션 ----------")
        print("⭐️ 점수: \(score)")
        print("📝 코멘트: \(comment)")
        
        // 비동기 작업 흉내 (1초 대기)
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) 
        print("✅ 전송 완료 처리됨")
    })
}
