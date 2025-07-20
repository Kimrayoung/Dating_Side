//
//  Methods.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation
import UIKit

func getAccessToken(from authHeader: String) -> String? {
    // "Bearer%2520" 다음부터 시작하는 부분 찾기
    guard let bearerRange = authHeader.range(of: "Bearer%2520") else {
        return nil
    }
    
    // Bearer%2520 이후의 문자열 가져오기
    let tokenStartIndex = bearerRange.upperBound
    
    // Bearer%2520 이후부터 첫 번째 ";" 이전까지 추출
    return String(authHeader[tokenStartIndex...])
}


func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
