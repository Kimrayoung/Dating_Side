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

enum PartnerProfileViewType {
    /// 매칭시도(대화하기 필요)
    case matching
    /// 채팅 탭에서 특정 사용자의 프로필을 누름(대화하기 필요)
    case chattingRequestMatch
    /// 매칭완료(대화하기 불필요)
    case matchComplete
    /// 매칭 시도 완료(대화하기 불필요)
    case matchingRequestComplete
}
