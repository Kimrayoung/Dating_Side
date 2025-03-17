//
//  UserProfileField.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import Foundation

enum UserProfileField {
    case nickname
    case birthYear
    case birthMonth
    case birthDay
    case height
    
    var focusedValue: Int {
        switch self {
        case .nickname: return 0
        case .birthYear, .birthMonth, .birthDay: return 1
        case .height: return 2
        }
    }
}

// 현재 포커스된 필드를 추적하기 위한 열거형
enum BirthFocusField: Hashable {
    case year(Int)
    case month(Int)
    case day(Int)
}

enum HeightFocusField: Hashable {
    case height(Int)
}
