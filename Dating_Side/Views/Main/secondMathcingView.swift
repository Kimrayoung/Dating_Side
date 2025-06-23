//
//  secondMathcingView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

struct secondMathcingView: View {
    @State private var showProfileView: Bool = false
    var body: some View {
        VStack(content: {
            Text("질문 주셔서 감사합니다.\n당신에게 딱 맞는 두번쨰 상대입니다.")
                .multilineTextAlignment(.center)
                .font(.pixel(20))
                .foregroundStyle(Color.whiteColor)
                .padding(.top, 20)
                .padding(.bottom, 6)
            Spacer()
            ProfileMiniView(isDefault: false, userImageURL: "https://picsum.photos/200/300", userName: "운명의 상대", userType: "따뜻한 연애")
                .clipShape(RoundedRectangle(cornerRadius: 8.85))
                .frame(width: 180, height: 180)
                .onTapGesture {
                    showProfileView.toggle()
                }
            Spacer()
        })
        .sheet(isPresented: $showProfileView, content: {
            ProfileView()
                .presentationDetents([.fraction(0.99)])
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
}

#Preview {
    secondMathcingView()
}
