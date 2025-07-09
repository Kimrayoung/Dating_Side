//
//  Account.swift
//  Dating_Side
//
//  Created by 김라영 on 7/9/25.
//

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
    let lifeStyleList: [LifeStyleList]
}

// MARK: - LifeStyleList
struct LifeStyleList: Codable {
    let category: String
    let contentList: [String]
}

enum PreferenceType: String {
    case before = "BEFORE"
    case after = "AFTER"
}
