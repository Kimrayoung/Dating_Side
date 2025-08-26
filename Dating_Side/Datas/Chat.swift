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

struct ChatMessage: Identifiable, Codable, Hashable {
    var id = UUID()
    let content: String
    let sender: Int
    let timestamp: Date
}

struct ChattingRoomResponse: Codable {
    let partnerNickName: String
    let partnerProfileImageUrl: String
    let lastMessage: String
    let lastMessageTime: Date
    let notReadMessageCount: Int
}
