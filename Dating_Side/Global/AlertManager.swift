//  AlertManager.swift
//  Dating_Side
//
//  Created for global CustomAlert management

import SwiftUI

class AlertManager: ObservableObject {
    static let shared = AlertManager()
    
    @Published var isPresented: Bool = false
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var primaryButtonText: String = ""
    @Published var secondaryButtonText: String? = nil
    @Published var secondaryButtonColor: Color = Color.gray3
    @Published var primaryButtonColor: Color = Color.mainColor
    
    var primaryButtonAction: () -> Void = {}
    var secondaryButtonAction: (() -> Void)? = nil
    
    // 전역 경고 노출
    func showAlert(title: String, message: String, primaryButtonText: String, primaryButtonColor: Color = Color.mainColor, primaryButtonAction: @escaping () -> Void = {}, secondaryButtonText: String? = nil, secondaryButtonColor: Color = Color.gray3, secondaryButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.primaryButtonText = primaryButtonText
        self.primaryButtonColor = primaryButtonColor
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonText = secondaryButtonText
        self.secondaryButtonColor = secondaryButtonColor
        self.secondaryButtonAction = secondaryButtonAction
        self.isPresented = true
    }
    
    func dismiss() {
        self.isPresented = false
    }
    
    func networkAlert(primaryAction: (() -> Void)? = nil) {
        showAlert(
            title: "네트워크 오류",
            message: "인터넷 연결을 확인해주세요.",
            primaryButtonText: "확인",
            primaryButtonColor: Color.red,
            primaryButtonAction: primaryAction ?? {}
        )
    }
    
    func serverAlert(primaryAction: (() -> Void)? = nil) {
        showAlert(
            title: "서버 오류",
            message: "서버와의 통신 중 문제가 발생했습니다.\n잠시 후 다시 시도해주세요.",
            primaryButtonText: "확인",
            primaryButtonColor: Color.gray3,
            primaryButtonAction: primaryAction ?? {}
        )
    }
    
    func clientAlert(message: String, primaryAction: (() -> Void)? = nil) {
        showAlert(
            title: "알림",
            message: message,
            primaryButtonText: "확인",
            primaryButtonColor: Color.mainColor,
            primaryButtonAction: primaryAction ?? {}
        )
    }
    
    func loginExpiredAlert(primaryAction: (() -> Void)? = nil) {
        showAlert(
            title: "알림",
            message: "로그인이 만료되었습니다.\n다시 로그인 해주세요.",
            primaryButtonText: "확인",
            primaryButtonColor: Color.mainColor,
            primaryButtonAction: primaryAction ?? {}
        )
    }
}

