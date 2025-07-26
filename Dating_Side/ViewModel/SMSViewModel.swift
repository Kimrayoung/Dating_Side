//
//  LoginViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import Foundation
import Combine

@MainActor
class SMSViewModel: ObservableObject {
    let smsNetworkManger = SMSNetworkManager()
    var smsBaseToken: String = ""
    
    @Published var phoneFrontNumber: [String] = ["", "", "", ""]
    @Published var phoneBackNumber: [String]
     = ["", "", "", ""]
    @Published var verificationNumber: [String] = ["", "", "", ""]
    
    
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
    
    func separateDigist(_ number: Int) -> [String] {
        let numberString = String(number)
        var digits: [String] = []
        
        for char in numberString {
            digits.append(String(char))
        }
        
        return digits
    }
}

// 기존 LoginView -> 핸드폰 로그인 추가
extension SMSViewModel {
    /// sms 인증시 필요한 Base Token가져오기
    func getSMSBaseToken() async {
        do {
            let smsBaseToken = try await smsNetworkManger.getSmsToken()
            switch smsBaseToken {
            case .success(let smsTokenResponse):
                self.smsBaseToken = smsTokenResponse.token
            case .failure(let error):
                Log.errorPublic("smsTokenResponse error: \(error)")
            }
        } catch {
//            Log.errorPublic("smsToken 실패: \(error)")
        }
    }
    
    /// 인증번호 요청
    func requestVerifiactionNumber() async {
        if smsBaseToken == "" { return }
        let phoneNumber = getPhoneNumber()

//        let separateDigit = separateDigist(1234)
//        for i in 0...3 {
//            verificationNumber[i] = separateDigit[i]
//        }
//        if checkPhoneNumbers() {
//            loginComplete = true
//        }

        let smsCodeRequest = SMSCodeRequest(phoneNumber: phoneNumber)
        do {
            let result = try await smsNetworkManger.getSmsCode(token: smsBaseToken, smsCodeRequest: smsCodeRequest)
            switch result {
            case .success(let sms):
                guard let code = Int(sms.code) else { return }
                let separateDigit = separateDigist(code)
                for i in 0...3 {
                    verificationNumber[i] = separateDigit[i]
                }
//                Log.networkPrivate("코드 수신 성공", code)
            case .failure(let error):
                Log.errorPublic("인증번호 받아오는 거 실패", error)
            }
        } catch {
//            Log.errorPublic("인증번호 받아오는 거 실패", error)
        }
    }
    
    /// 인증번호 검증(확인)
    func verifySMSCode() async -> Bool {
        let phoneNumber = getPhoneNumber()
        let verificationNumber = getVerificationNumber()

        let smsVerifyRequest = SMSVerifyRequest(phoneNumber: phoneNumber, code: verificationNumber)
        do {
            let result = try await smsNetworkManger.verifySmsCode(smsVerifyRequest: smsVerifyRequest)
            switch result {
            case .success:
//                Log.errorPrivate("검증 성공")
                return true
            case .failure(let error):
                Log.errorPublic("검증 실패", error)
            }
        } catch {
//            Log.errorPublic("검증 실패", error)
        }
        return false
    }
}
