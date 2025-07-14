//
//  AppDelegate.swift
//  Dating_Side
//
//  Created by 김라영 on 7/14/25.
//

import Foundation
import UIKit
import NidThirdPartyLogin

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        if NidOAuth.shared.handleURL(url) {
//            return true
//        }

        return false
    }
}
