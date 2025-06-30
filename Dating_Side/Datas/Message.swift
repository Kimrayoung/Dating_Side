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

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool
    let timestamp: Date
}
