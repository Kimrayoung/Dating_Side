//
//  LeaveAlertView.swift
//  Dating_Side
//
//  Created by 김라영 on 9/25/25.
//

import SwiftUI

/// 상대방이 떠났음 -> 상대방이 보낸 메시지 확인 가능
struct LeaveAlertView: View {
    @State private var partnerLeaveMessage: String = "당신은 안정적이며 의지할 수 있는 관계를 중요하게 생각합니다. 연애에서는 함께 시간을 보내는 것과 서로의 안정을 우선시하고, 공감하고 이해해주는 파트너를 선호합니다, 이전 연애에서는 아마도 깊은 유대감을 형성하려 했을 것이며, 앞으로도 의지할 수 있는 관계를 추구할 것으로 보입니다. 감정 표현에서는 행동으로 마음을 전하는 경향이 있습니다."
    
    var body: some View {
        VStack {
            Text("당신의 답장을 토대로\n오늘의 카드가 완성 되었어요")
                .foregroundStyle(Color.whiteColor)
                .font(.pixel(20))
                .multilineTextAlignment(.center)
                .padding(.bottom, 51)
                .padding(.top, 70)
            leaveMessage
            
            confirmMatchingPartner
                .padding(.top, 103)
                .padding(.bottom, 44)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    var leaveMessage: some View {
        ScrollView {
            Text(partnerLeaveMessage)
                .font(.pixel(16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25.5)
                .padding(.vertical, 25)
        }
        .background(
            LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.whiteColor.opacity(0.25), location: 0.0),   // 0%
                        .init(color: Color.white.opacity(0.2), location: 0.51),  // 51%
                        .init(color: Color.white.opacity(0.35), location: 1.0)    // 100%
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
                            .init(color: Color.white.opacity(0.6), location: 1.0)   // 100%
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
        )
        .frame(width: 316)
        .frame(maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 38.5)
    }
    
    var confirmMatchingPartner: some View {
        Button {
            
        } label: {
            Text("매칭 상대 확인하기")
                .font(.pixel(16))
                .foregroundStyle(Color.whiteColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.mainColor)
        )
        .padding(.horizontal, 24)
    }
    
}

#Preview {
    LeaveAlertView()
}
