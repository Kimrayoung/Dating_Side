//
//  View+Ext.swift
//  Dating_Side
//
//  Created by 김라영 on 8/17/25.
//

import SwiftUI

// 뷰 수정자로 사용하기 위한 확장
extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButtonText: String,
        primaryButtonAction: @escaping () -> Void,
        primaryButtonColor: Color = .mainColor,
        secondaryButtonText: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        secondaryButtonColor: Color = .gray3
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomAlert(
                    title: title,
                    message: message,
                    primaryButtonText: primaryButtonText,
                    primaryButtonAction: primaryButtonAction,
                    primaryButtonColor: primaryButtonColor,
                    secondaryButtonText: secondaryButtonText,
                    secondaryButtonAction: secondaryButtonAction,
                    secondaryButtonColor: secondaryButtonColor,
                    isPresented: isPresented
                )
            }
        }
    }
    
    func customToastPopup(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomToastPopup(
                    title: title,
                    message: message,
                    isPresented: isPresented
                )
            }
        }
    }
}
