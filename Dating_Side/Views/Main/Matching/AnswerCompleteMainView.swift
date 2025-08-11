//
//  AnswerCompleteMainView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/11/25.
//

import SwiftUI
/// 답변완료시 메인 화면

struct AnswerCompleteMainView: View {
    var body: some View {
        VStack {
            Text("당신의 답변을 토대로\n오늘의 카드가 완성 되었어요")
                .multilineTextAlignment(.center)
                .font(.pixel(20))
            Text("전체 카드는 마이페이지에서 확인 하세요")
                .font(.pixel(12))
            VStack {
                Text("[연애]")
                    .font(.pixel(12))
                    .padding(.bottom, 16)
                Text("당신은 안정적이며 의지할 수 있는 관계를 중요하게 생각합니다.\n\n연애에서는 함께 시간을 보내는 것과 서로의 안정을 우선시하고, 공감하고 이해해주는 파트너를 선호합니다. \n\n이전 연애에서는 아마도 깊은 유대감을 형성하려 했을 것이며, 앞으로도 의지할 수 있는 관계를 추구할 것으로 보입니다. 감정 표현에서는 행동으로 마음을 전하는 경향이 있습니다.")
                    .font(.pixel(16))
                    
            }
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
            sendQuestion
                .padding(.top, 43)
                .padding(.bottom, 12)
            confirmPartner
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    var sendQuestion: some View {
        Button {
            
        } label: {
            Text("질문 보내기")
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
