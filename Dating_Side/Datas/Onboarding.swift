//
//  Onboarding.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation

struct UserProfile: Codable {
    let gender, activeRegion, preferenceType, nickname: String?
    let birthDate: String?
    let height: Int?
    let highestEducation, job: String?
    let sensitiveInfo: SensitiveInfo?
    let profileImage: ProfileImage?
    let introduction: String?
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let profileImage: String?
}

// MARK: - SensitiveInfo
struct SensitiveInfo: Codable {
    let isDrink, isSmoke, hasTattoo, hasReligion: String?
}
