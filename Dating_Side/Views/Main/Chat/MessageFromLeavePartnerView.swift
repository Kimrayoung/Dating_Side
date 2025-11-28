//
//  MessageFromLeavePartnerView.swift
//  Dating_Side
//
//  Created by 안세훈 on 11/28/25.
//

import SwiftUI

struct MessageFromLeavePartnerView: View {
    
    @State private var showModal = false
    @State private var bottomSheetStartHeight: CGFloat = 0.6
    
    var body: some View {
        ZStack {
            Image("matchingViewBg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("당신의 답장을 토대로\n프로필이 완성 되었어요")
                        .font(.pixel(20))
                        .multilineTextAlignment(.center)
                    
                    Text("전체 프로필은 마이페이지에서 확인 하세요")
                        .font(.pixel(12))
                }
                .padding(.top, 50)
                .padding(.bottom, 65)
                
                ScrollView {
                    Text("profileContent")
                        .font(.pixel(16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25.5)
                        .padding(.vertical, 25)
                }
                .background(Color.white)
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
            //            if matchingStatus != .MATCHED {
            //
            //            } else {
            //                appState.matchingPath.append(Matching.matchingProfileCheckView)
            //            }
            
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
    MessageFromLeavePartnerView()
}
