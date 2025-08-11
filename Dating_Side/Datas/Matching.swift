//
//  Attraction.swift
//  Dating_Side
//
//  Created by 김라영 on 8/7/25.
//

struct PartnerRequest: Codable {
    let partnerId: Int
}

struct PartnerScore: Codable {
    let socre: Int
}

struct UserImage: Codable {
    let isSuccess: Bool
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case profileImageURL = "profileImageUrl"
    }
}

struct MatchingStatusResponse: Codable {
    let result: Bool
}

struct MatchingAccountResponse: Codable {
    let result: PartnerAccount
}
