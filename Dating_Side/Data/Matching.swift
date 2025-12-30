//
//  Attraction.swift
//  Dating_Side
//
//  Created by 김라영 on 8/7/25.
//

import Foundation

struct PartnerRequest: Codable {
    let partnerId: Int
}

struct PartnerScore: Codable {
    let score: Int
    let comment: String
}

struct UserImage: Codable {
    let isSuccess: Bool
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case profileImageURL = "profileImageUrl"
    }
}

struct MatchingStatusResponse: Codable {
    let matchingStatus: String
    let matchedAt: [Int]?
    let scoreFromPartner: PartnerEvaluation?
    
    var matchingStatusType: MatchingStatusType {
        switch matchingStatus {
        case "ATTRACTED":
            return .ATTRACTED
        case "LEFT":
            return .LEFT
        case "MATCHED":
            return .MATCHED
        default:
            return .UNMATCHED
        }
    }
    
    var timestampDate: Date? {
        guard let matchedAt = matchedAt else { return nil }
        guard matchedAt.count >= 6 else { return nil }
        
        var comps = DateComponents()
        comps.year   = matchedAt[0]
        comps.month  = matchedAt[1]
        comps.day    = matchedAt[2]
        comps.hour   = matchedAt[3]
        comps.minute = matchedAt[4]
        comps.second = matchedAt[5]
        
        if matchedAt.count >= 7 {
            comps.nanosecond = matchedAt[6]
        }
        return Calendar.current.date(from: comps)
    }
}

struct PartnerEvaluation: Codable {
    let score: Int?
    let comment: String?
}

struct MatchingAccountResponse: Codable {
    let result: PartnerAccount
}

enum MatchingStatusType: String {
    case UNMATCHED //매칭 안됨
    case MATCHED //매칭 됨
    case LEFT //상대가 나감
    case ATTRACTED // 나한테 다가옴
    case ATTRACTING //내가 다가감
    case DELETE //상대가 탈퇴함
}
