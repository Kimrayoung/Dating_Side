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
