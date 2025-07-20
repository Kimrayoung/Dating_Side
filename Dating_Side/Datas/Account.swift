//
//  Account.swift
//  Dating_Side
//
//  Created by 김라영 on 7/9/25.
//

import Foundation
import UIKit

struct SignupRequest: Codable {
    let socialType: String
    let userSocialId: String
    let phoneNumber: String
    var genderType: String
    var nickName: String
    var birthDate: String
    var height: Int
    var activeRegion: String
    var beforePreferenceTypeList: [String]
    var afterPreferenceTypeList: [String]
    var edcationType: String
    var educationDetail: String
    var jobType: String
    var jobDetail: String
    var lifeStyle: LifeStyle
    var introduction: String
    var fcmToken: String
}

struct AccountImage {
    var imageTitle: String
    var image: UIImage
}

extension SignupRequest {
    func toMultipartFormBuilder(images: [AccountImage]) -> MultipartFormDataBuilder {
        var builder = MultipartFormDataBuilder()

        // 1) JSON 전체를 `request` 파트로 추가
        builder.appendJSONField(named: "request", value: self)

        // 2) 이미지들 추가
        for img in images {
            builder.appendImageField(named: img.imageTitle, image: img.image)
        }

        // 3) 마무리 boundary
        builder.finalize()

        return builder
    }
}



struct UserData: Codable {
    var genderType: String
    var nickName: String
    var birthDate: String
    var height: Int
    var activeRegion: String
    var beforePreferenceTypeList: [String]
    var afterPreferenceTypeList: [String]
    var edcationType: String
    var educationDetail: String
    var jobType: String
    var jobDetail: String
    var lifeStyle: LifeStyle
    var introduction: String
    var fcmToken: String
}

struct LifeStyle: Codable {
    let drinking: String
    let smoking: String
    let tatto: String
    let religion: String
}

struct Address: Codable {
    let code: String
    let addrName: String
}

struct LifeStyleResponse: Codable {
    let lifeStyleList: [LifeStyleContent]
}

// MARK: - LifeStyleList
struct LifeStyleContent: Codable {
    let category: String
    let choices: [String]
}

enum PreferenceType: String {
    case before = "BEFORE"
    case after = "AFTER"
}

enum ImageType {
    case mainProfile
    case secondDay
    case forthDay
    case sixthDay
}

struct UserAccount: Codable {
    let id: Int
    let phoneNumber, genderType, nickName, birthDate: String
    let height: Int
    let activeRegion: String
    let beforePreferenceTypeList, afterPreferenceTypeList: [String]
    let keyword, educationType, educationDetail, jobType: String
    let jobDetail: String
    let lifeStyle: LifeStyle
    let profileImageURL: String
    let profileImageURLByDay: ProfileImageURLByDay
    let introduction: String
    let mannerTemperature: Int

    enum CodingKeys: String, CodingKey {
        case id, phoneNumber, genderType, nickName, birthDate, height, activeRegion, beforePreferenceTypeList, afterPreferenceTypeList, keyword, educationType, educationDetail, jobType, jobDetail, lifeStyle
        case profileImageURL = "profileImageUrl"
        case profileImageURLByDay = "profileImageUrlByDay"
        case introduction, mannerTemperature
    }
}

// MARK: - ProfileImageURLByDay
struct ProfileImageURLByDay: Codable {
    let daySecond, dayFourth, daySixth: String
}
