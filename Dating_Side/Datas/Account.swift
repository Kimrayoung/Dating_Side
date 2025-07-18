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
    func toMultipartFormBuilder(images: [AccountImage]) -> MultipartFormDataBuilder? {
        var builder = MultipartFormDataBuilder()

        // 1. 모든 프로퍼티 → key-value로 자동 추출
        guard let keyValuePairs = self.toKeyValuePairs() else { return nil }

        for (key, value) in keyValuePairs {
            builder.appendTextField(named: key, value: value)
        }

        for image in images{
            builder.appendImageField(named: image.imageTitle, image: image.image)
        }

        // 3. 종료 바운더리
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
