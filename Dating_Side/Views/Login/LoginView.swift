//
//  LoginView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/04/09.
//

import SwiftUI

struct LoginView: View {
    @State var isSelectedB: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("이미 계정이 있으시다면 로그인")
                .font(.pixel(12))
                .foregroundColor(.black)
                .padding(.bottom, 8)
            
            SelectButtonLabel(isSelected: $isSelectedB, height: 48, text: "전화번호로 시작하기", backgroundColor: .white, selectedBackgroundColor: .white, textColor: .black, selectedTextColor: .black, cornerRounded: 8, font: .pixel(16), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0, strokeBorderLineColor: .white, selectedStrokeBorderColor: .white)
                .padding(.bottom, 88)
                .padding(.horizontal, 24)
                .shadow(color: Color.mainColor.opacity(0.25), radius: 10, x: 0, y: 9)
        }
        .background(
            Image("bgImg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LoginView()
}
