//
//  NaverAuth.swift
//  Dating_Side
//
//  Created by 김라영 on 7/14/25.
//

import NidThirdPartyLogin
import Combine
import UIKit

class NaverAuth: ObservableObject {
    func isNaverAppInstalled() -> Bool {
        return UIApplication.shared.canOpenURLScheme("\(Constant.naverAppThirdLoginScheme)://")
    }
    
    func handleNaverLogin() {
        if isNaverAppInstalled() {
            NidOAuth.shared.setLoginBehavior(.app)
        } else {
            NidOAuth.shared.setLoginBehavior(.inAppBrowser)
        }
        naverLogin()
    }
    
    func naverLogin() {
        NidOAuth.shared.requestLogin { result in
          switch result {
          case .success(let loginResult):
            print("Access Token: ", loginResult.accessToken.tokenString)
          case .failure(let error):
            print("Error: ", error.localizedDescription)
          }
        }
    }
}

