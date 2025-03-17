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
    @Published var phoneFrontNumber: [String] = ["", "", "", ""]
    @Published var phoneBackNumber: [String]
     = ["", "", "", ""]
    @Published var verificationNumber: [String] = ["", "", "", ""]
    
    func checkPhoneNumbers() -> Bool{
        return !self.phoneFrontNumber.contains("") && !self.phoneBackNumber.contains("")
    }
    
    func checkVerificationNumber() -> Bool {
        return !self.verificationNumber.contains("")
    }
    
    func getPhoneNumber() -> String {
        let front = phoneFrontNumber.joined()
        let back = phoneBackNumber.joined()
        return "010-\(front)-\(back)"
    }
}
