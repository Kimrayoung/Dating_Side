//
//  ChatMessageComponent.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/26.
//

import SwiftUI

// MARK: - 메시지 버블
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if !message.isCurrentUser { // 상대방 프로필 (본인의 프로필은 보이지 않음)
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
                
            }
            Text(message.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(message.isCurrentUser ? Color.mainColor : Color.subColor)
                )
                .foregroundColor(message.isCurrentUser ? .white : .primary)
                
        }
    }
}

// MARK: - 메시지 행
struct MessageRow: View {
    let message: ChatMessage
    let showTimestamp: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if message.isCurrentUser {
                Spacer()
                MessageBubble(message: message)
                    .offset(x: showTimestamp ? -40 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showTimestamp)
//                    .animation(.easeInOut(duration: 0.2), value: showTimestamp)
                if showTimestamp {
                    Text("→ \(message.timestamp.hourAndMinuteString)")
                        .font(.pixel(12))
                        .foregroundStyle(Color.gray3)
                        .transition(.opacity)
                        .padding(.trailing, 4)
                }
            } else {
                MessageBubble(message: message)
                    .offset(x: showTimestamp ? -80 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showTimestamp)
                Spacer()
                if showTimestamp {
                    Text("→ \(message.timestamp.hourAndMinuteString)")
                        .font(.pixel(12))
                        .foregroundStyle(Color.gray3)
                        .transition(.opacity)
                        .padding(.leading, 4)
                }

            }
        }
        .padding(.horizontal)
    }

}
