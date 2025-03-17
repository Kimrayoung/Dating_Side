//
//  LoginViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var phoneNumber: [String] = ["", "", "", "", "", "", "", ""]
    @Published var verificationNumber: String = ""
    
//    func checkNumbers() -> Bool{
//        if phoneNumber != "" && verificationNumber != "" { return true }
//        return false
//    }
}
