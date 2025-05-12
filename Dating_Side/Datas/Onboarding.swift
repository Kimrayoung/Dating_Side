//
//  Onboarding.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation

struct UserProfileResponse: Codable {
    let result: Bool
    let data: UserProfile
}

struct UserProfile: Codable {
    var gender, activeRegion, preferenceType, nickname: String?
    var birthDate: String?
    var height: Int?
    var highestEducation, job: String?
    var sensitiveInfo: SensitiveInfo?
    var profileImage: ProfileImage?
    var introduction: String?
    var createdAt: String?
    var updatedAt: String?
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let profileImage: String?
}

// MARK: - SensitiveInfo
struct SensitiveInfo: Codable {
    let isDrink, isSmoke, hasTattoo, hasReligion: String?
}

struct ResponseBoolean: Codable {
    let result: Bool
}

enum OnboardingUpdateType {
    case gender
    case nickname
    case birth
    case height
    case location
    case loveKeyword
    case highestEducation
    case job
    case sensitiveInfo
    case profileImage
    case introduction
}
