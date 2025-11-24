//
//  ChatMessageComponent.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/26.
//

import SwiftUI
import Kingfisher

// MARK: - 메시지랑 프로필
struct MessageProfile: View {
    @Binding var showProfile: Bool
    @State var partnerImageUrl: String?
    let message: ChatMessage
    let userID = UserDefaults.standard.integer(forKey: "userId")
    
    var body: some View {
        HStack {
            if message.sender != userID { // 상대방 프로필 (본인의 프로필은 보이지 않음)
                Group {
                    if let partnerImageUrl = partnerImageUrl {
                        KFImage(URL(string: partnerImageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .onTapGesture {
                    showProfile.toggle()
                }
            }
            Text(message.content)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(message.sender == userID ? Color.mainColor : Color.subColor)
                )
                .foregroundColor(message.sender == userID ? .white : .primary)
        }
    }
}

// MARK: - 메시지 행
struct MessageRow: View {
    let message: ChatMessage
    let partnerImageUrl: String
    let showTimestamp: Bool
    let userID = UserDefaults.standard.integer(forKey: "userId")
    @Binding var showProfile: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if message.sender ==  userID {
                Spacer()
                MessageProfile(showProfile: $showProfile, partnerImageUrl: "", message: message)
                    .offset(x: showTimestamp ? -40 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showTimestamp)
                //                    .animation(.easeInOut(duration: 0.2), value: showTimestamp)
                if showTimestamp {
                    Text("→ \(message.timestampDate?.hourAndMinuteString ?? Date().hourAndMinuteString)")
                        .font(.pixel(12))
                        .foregroundStyle(Color.gray3)
                        .transition(.opacity)
                        .padding(.trailing, 4)
                }
            } else {
                MessageProfile(showProfile: $showProfile, partnerImageUrl: partnerImageUrl, message: message)
                    .offset(x: showTimestamp ? -80 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showTimestamp)
                Spacer()
                if showTimestamp {
                    Text("→ \(message.timestampDate?.hourAndMinuteString ?? Date().hourAndMinuteString)")
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
