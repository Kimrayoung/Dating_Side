//
//  Message.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/24.
//

import Foundation

struct UserMessage: Codable {
    let message: String
    let time: Date
}

struct SocketMessage: Codable, Hashable {
    let content: String
    let roomId: String
}

struct ChatPayload: Decodable {
    let roomId: String
    let sender: Int
    let content: String
}

struct ChatMessage: Identifiable, Codable, Hashable {
    var id = UUID()
    let content: String
    let sender: Int
    let timestamp: [Int]
    
    enum CodingKeys: String, CodingKey {
        case content, sender, timestamp
    }
    
    var timestampDate: Date? {
        guard timestamp.count >= 6 else { return nil }
        var comps = DateComponents()
        comps.year   = timestamp[0]
        comps.month  = timestamp[1]
        comps.day    = timestamp[2]
        comps.hour   = timestamp[3]
        comps.minute = timestamp[4]
        comps.second = timestamp[5]
        if timestamp.count >= 7 {
            comps.nanosecond = timestamp[6]
        }
        return Calendar.current.date(from: comps)
    }
}

struct ChattingRoomResponse: Codable {
    let roomId: String
    let partnerNickName: String
    let partnerProfileImageUrl: String
    let lastMessage: String?
    let lastMessageTime: [Int]
    let notReadMessageCount: Int
    
    var timestampDate: Date? {
        guard lastMessageTime.count >= 6 else { return nil }
        var comps = DateComponents()
        comps.year   = lastMessageTime[0]
        comps.month  = lastMessageTime[1]
        comps.day    = lastMessageTime[2]
        comps.hour   = lastMessageTime[3]
        comps.minute = lastMessageTime[4]
        comps.second = lastMessageTime[5]
        if lastMessageTime.count >= 7 {
            comps.nanosecond = lastMessageTime[6]
        }
        return Calendar.current.date(from: comps)
    }
}
