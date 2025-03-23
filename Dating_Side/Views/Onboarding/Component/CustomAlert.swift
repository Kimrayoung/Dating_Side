//
//  CustomAlert.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/23.
//

import SwiftUI

struct CustomAlert: View {
    var title: String
    var message: String
    var primaryButtonText: String
    var primaryButtonAction: () -> Void
    var secondaryButtonText: String?
    var secondaryButtonAction: (() -> Void)?
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
                
                // 버튼
                HStack(spacing: 8) {
                    // 보조 버튼 (있는 경우)
                    if let secondaryButtonText = secondaryButtonText,
                       let secondaryButtonAction = secondaryButtonAction {
                        Button(action: {
                            isPresented.wrappedValue = false
                            secondaryButtonAction()
                        }) {
                            Text(secondaryButtonText)
                                .font(.pixel(16))
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(Color.gray3)
                                .background(Color.gray0)
                                .cornerRadius(10)
                        }
                    }
                    
                    // 주요 버튼(기본 버튼)
                    Button(action: {
                        isPresented.wrappedValue = false
                        primaryButtonAction()
                    }) {
                        Text(primaryButtonText)
                            .font(.pixel(16))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(Color.white)
                            .background(Color.mainColor)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(30)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding(30)
        }
    }
}

// 뷰 수정자로 사용하기 위한 확장
extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButtonText: String,
        primaryButtonAction: @escaping () -> Void,
        secondaryButtonText: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomAlert(
                    title: title,
                    message: message,
                    primaryButtonText: primaryButtonText,
                    primaryButtonAction: primaryButtonAction,
                    secondaryButtonText: secondaryButtonText,
                    secondaryButtonAction: secondaryButtonAction,
                    isPresented: isPresented
                )
            }
        }
    }
}

#Preview {
    CustomAlert(title: "회원가입을 중단하고\n시작화면으로 나갈까요?", message: "나가면 입력한 정보가 저장되지 않아요", primaryButtonText: "나가기", primaryButtonAction: {}, secondaryButtonText: "취소", secondaryButtonAction: {}, isPresented: .constant(true))
}
