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
    let loginNetworkManger = LoginNetworkManager()
    @Published var socialType: String = ""
    @Published var userSocialID: String = ""
    
    @Published var phoneFrontNumber: [String] = ["", "", "", ""]
    @Published var phoneBackNumber: [String]
     = ["", "", "", ""]
    @Published var verificationNumber: [String] = ["", "", "", ""]
    @Published var loginComplete: Bool = false
    
    func login() async {
        let loginRequest = LoginRequest(userSocialId: userSocialID)
        do {
            let result = try await loginNetworkManger.login(loginRequest: loginRequest)
            switch result {
            case .success:
                print(#fileID, #function, #line, "- success")
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error)")
        }
    }
}

// 기존 LoginView -> 핸드폰 로그인 추가
extension LoginViewModel {
    // 핸드폰 번호에 빈문자열이 들어가져 있는지 확인
    func checkPhoneNumbers() -> Bool{
        return !self.phoneFrontNumber.contains("") && !self.phoneBackNumber.contains("")
    }
    
    // 인증번호에 빈 문자열이 들어가져 있는지 확인
    func checkVerificationNumber() -> Bool {
        return !self.verificationNumber.contains("")
    }
    
    // 핸드폰 번호 합쳐서 가져오기
    func getPhoneNumber() -> String {
        let front = phoneFrontNumber.joined()
        let back = phoneBackNumber.joined()
        return "010-\(front)-\(back)"
    }
    
    // 인증번호 합쳐서 가져오기
    func getVerificationNumber() -> String {
        return verificationNumber.joined()
    }
    
    // sms 인증시 필요한 Base Token가져오기
//    func accoutSignup() async -> String? {
//        do {
//            let result = try await loginNetworkManger.accountSignup()
//            switch result {
//            case .success(let baseToken):
//                return baseToken.smsTempToken
//            case .failure(let error):
//                return nil
//            }
//        } catch {
//            return nil
//        }
//        return nil
//    }
    
    // 인증번호 요청
//    func requestVerifiactionNumber() async {
//        let phoneNumber = getPhoneNumber()
//        guard let getSMSToken = await getSMSToken() else { return }
//        print(#fileID, #function, #line, "- phoneNumer check: \(phoneNumber), smsToken check: \(getSMSToken)")
//        let separateDigit = separateDigist(1234)
//        for i in 0...3 {
//            verificationNumber[i] = separateDigit[i]
//        }
//        if checkPhoneNumbers() {
//            loginComplete = true
//        }
//
//        let loginSMSReuquest = LoginSMSRequest(phoneNumber: phoneNumber, smsToken: getSMSToken)
//        do {
//            let result = try await loginNetworkManger.smsRequest(loginSMSReuquest)
//            switch result {
//            case .success(let sms):
//                let separateDigit = separateDigist(sms.number)
//                for i in 0...3 {
//                    verificationNumber[i] = separateDigit[i]
//                }
//            case .failure(let error):
//                print(#fileID, #function, #line, "- error")
//            }
//        } catch {
//            print(#fileID, #function, #line, "- error: \(error)")
//        }
//    }
    
    func separateDigist(_ number: Int) -> [String] {
        let numberString = String(number)
        var digits: [String] = []
        
        for char in numberString {
            digits.append(String(char))
        }
        
        return digits
    }
    
    // 인증번호 검증(확인)
    func checkRequestNumber() async -> Bool {
        let phoneNumber = getPhoneNumber()
        let verificationNumber = getVerificationNumber()
//        guard let getSMSToken = await getSMSToken() else { return false }
        
        let check = LoginSMSVerify(phoneNumber: phoneNumber, number: verificationNumber)
//        do {
//            let result = try await loginNetworkManger.smsVerify(check, getSMSToken)
//            switch result {
//            case .success(let complete):
//                print(#fileID, #function, #line, "- check true: \(complete)")
//
//                return complete.result
//            case .failure(let error):
//                print(#fileID, #function, #line, "- error: \(error)")
//            }
//        } catch {
//            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
//        }
        return false
    }
}
