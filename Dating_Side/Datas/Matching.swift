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
    let comment: String
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
    let matchingStatus: String
    let scoreFromPartner: PartnerEvaluation
    
    var matchingStatusType: MatchingStatusType {
        switch matchingStatus {
        case "LEFT":
            return .LEFT
        case "MATCHED":
            return .MATCHED
        default:
            return .UNMATCHED
        }
    }
}

struct PartnerEvaluation: Codable {
    let score: Int?
    let comment: String?
}

struct MatchingAccountResponse: Codable {
    let result: PartnerAccount
}


enum MatchingStatusType: String{
    case UNMATCHED
    case MATCHED
    case LEFT
}
