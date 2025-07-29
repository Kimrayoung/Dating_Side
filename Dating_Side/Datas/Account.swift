//
//  Account.swift
//  Dating_Side
//
//  Created by 김라영 on 7/9/25.
//

import Foundation
import UIKit


struct SignUpRequest: Codable {
    let socialType: String
    let socialAccessToken: String
    let phoneNumber: String
    var genderType: String
    var nickName: String
    var birthDate: String
    var height: Int
    var activeRegion: String
    var beforePreferenceTypeList: [String]
    var afterPreferenceTypeList: [String]
    var educationType: String
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
    let tattoo: String
    let religion: String
}

struct AccountImage {
    var imageTitle: String
    var image: UIImage
}

/// 주소 관련(code, 주소 이름)
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
    let choices: [KoreanData]
}

/// 선호 키워드 종류(before, after)
enum PreferenceType: String {
    case before = "BEFORE"
    case after = "AFTER"
}

/// ImageType(온보딩 사진 타입)
enum ImageType {
    /// 메인 프로필
    case mainProfile
    /// 둘째날
    case secondDay
    /// 넷째날
    case forthDay
    /// 여섯째날
    case sixthDay
}

/// 한글이랑 key랑 매핑 필요한 데이터(ex. 선호도 키워드)
struct KoreanData: Codable, Equatable, Hashable {
    let type: String
    let korean: String
}

/// 학력 영어 매핑
enum EducationEnglish: String, CaseIterable {
    case highSchool           = "HIGH_SCHOOL"
    case universityEnrolled   = "UNIVERSITY_ENROLLED"
    case universityGraduated  = "UNIVERSITY_GRADUATED"
    case master               = "MASTER"
    case doctoral             = "DOCTORAL"
    case etc                  = "ETC"
    
    /// 한글 표현
    var korean: String {
        switch self {
        case .highSchool:
            return "고등학교"
        case .universityEnrolled:
            return "대학교 재학 중"
        case .universityGraduated:
            return "대학교 졸업"
        case .master:
            return "석사"
        case .doctoral:
            return "박사"
        case .etc:
            return "기타"
        }
    }
}

/// 저장된 유저정보
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

struct ProfileImageURLByDay: Codable {
    let daySecond, dayFourth, daySixth: String
}

