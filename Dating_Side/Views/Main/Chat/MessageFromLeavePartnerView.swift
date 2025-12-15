//
//  MessageFromLeavePartnerView.swift
//  Dating_Side
//
//  Created by 안세훈 on 11/28/25.
//

import SwiftUI

struct MessageFromLeavePartnerView: View {
    
    @State private var showReplyModal = false
    @State private var bottomSheetStartHeight: CGFloat = 0.6
    @AppStorage("matchingStatus") private var matchingStatusRaw: String = MatchingStatusType.UNMATCHED.rawValue

    private var matchingStatus: MatchingStatusType {
        get { MatchingStatusType(rawValue: matchingStatusRaw) ?? .UNMATCHED }
        set { matchingStatusRaw = newValue.rawValue }
    }
    
    var body: some View {
        ZStack {
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 60) {
                VStack(spacing: 6) {
                    Text("[]님이\n대화를 떠났습니다.")
                        .font(.pixel(20))
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)
                    
                    Text("메세지를 확인하고 상대에게\n 작별인사를 전해주세요.")
                        .font(.pixel(12))
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)

                }
                
                ScrollView {
                    Text("profileContent")
                        .font(.pixel(16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25.5)
                        .padding(.vertical, 25)
                }
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
                .overlay(
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
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 316, height: 329)
                .padding(.horizontal, 38.5)
                                
                confirmPartner
            }
        }
        
    }
    
    /// 매칭상대 확인하기
    var confirmPartner: some View {
        Button {
            
        } label: {
            Text("답장하기")
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
    MessageFromLeavePartnerView()
}
