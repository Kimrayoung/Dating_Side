//
//  CustomToastPopup.swift
//  Dating_Side
//
//  Created by 김라영 on 8/17/25.
//

import SwiftUI

struct CustomToastPopup: View {
    var title: String
    var message: String
    var isPresented: Binding<Bool>
    
    var body: some View {
        ZStack {
            // 배경 오버레이
            Color.black.opacity(0.68)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                     isPresented.wrappedValue = false
                }
            
            // 알림창 본문
            VStack(spacing: 0) {
                // 제목
                Text(title)
                    .font(.pixel(20))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6)
                
                // 메시지
                Text(message)
                    .font(.pixel(14))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                
            }
            .padding(30)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding(30)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isPresented.wrappedValue = false
                }
            }
        }
    }
}

#Preview {
    CustomToastPopup(title: "하하", message: "히히", isPresented: .constant(false))
}
