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
}

// 어떤 뷰에서 프로필을 보여주는지
enum ShowProfileViewType {
    case chat
    case myPage
}
