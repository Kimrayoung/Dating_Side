//
//  Profile.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/26.
//

import Foundation

struct ValueData: Hashable, Codable {
    let text: String
}

struct TomeUserProfile: Hashable, Codable {
    let userName: String
    let userImage: String
    let userType: String
}

///가치관 기록
enum ProfileValueType {
    case couple
    case marry
    case company
    case life
    
    var korean: String {
        switch self {
            case .couple: return "연애관"
            case .marry: return "혼인관"
            case .company: return "기업관"
            case .life: return "생활관"
        }
    }
    
    var english: String {
        switch self {
            case .couple: return "LOVE"
            case .marry: return "MARRY"
            case .company: return "COMPANY"
            case .life: return "LIFE"
        }
    }
}

// 어떤 뷰에서 프로필을 보여주는지
enum ShowProfileViewType {
    case chat
    case myPage
    case matcing
    case onboarding
}
