//
//  AlertManager.swift
//  Dating_Side
//
//  Created by 김라영 on 7/21/25.
//

import SwiftUI

class AlertManager: ObservableObject {
    static let shared = AlertManager()  // 싱글톤

    @Published var isPresented: Bool = false
    @Published var title: String = ""
    @Published var message: String = ""
    var button: Alert.Button = .default(Text("확인"))

    private init() {}

    func showAlert(title: String, message: String, button: Alert.Button = .default(Text("확인"))) {
        self.title = title
        self.message = message
        self.button = button
        self.isPresented = true
    }
}
