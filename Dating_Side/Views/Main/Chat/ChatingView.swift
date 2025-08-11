//
//  ChatMessageComponent.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/26.
//

import SwiftUI

// MARK: - 채팅 뷰
struct ChatingView: View {
    @EnvironmentObject private var appState: AppState
    let buttonTitles: [String] = ["아주 좋아요", "좋아요", "보통이에요", "별로에요", "최악이에요"]
    let buttonColors: [Color] = [.mainColor, .subColor2, .gray01, .gray2, .gray3]
    @State private var username: String = "user"
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "안녕하세요^^", isCurrentUser: false, timestamp: Date().addingTimeInterval(-300)),
        ChatMessage(text: "반가워요! 테스트 중입니다.\n멀티라인 테스트", isCurrentUser: true, timestamp: Date().addingTimeInterval(-240)),
        ChatMessage(text: "넵 확인했습니다!", isCurrentUser: false, timestamp: Date().addingTimeInterval(-180)),
        ChatMessage(text: "좋아요~", isCurrentUser: true, timestamp: Date().addingTimeInterval(-120)),
    ]

    @State private var showTimestamps = false
    @State private var messageText = ""
    @State private var showProfile: Bool = false
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { _ in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageRow(message: message, showTimestamp: showTimestamps, showProfile: $showProfile)
                        }
                    }
                    .padding(.top)
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onChanged { value in
                        if value.translation.width < -30 {
                            withAnimation {
                                showTimestamps = true
                            }
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            showTimestamps = false
                        }
                    }
            )

            // 입력창
            sendTextField
        }
        
        .sheet(isPresented: $showProfile, content: {
            OnChatProfileView(profileShow: $showProfile)
                .presentationDetents([.fraction(0.99)])
                .presentationCornerRadius(10)
                .presentationDragIndicator(.visible)
        })
    }
    
    var sendTextField: some View {
        ZStack {
            TextField("메세지 보내기", text: $messageText)
                .textFieldStyle(MyTextFieldStyle())
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
            }
            .frame(width: 43, height: 33)
            .background(Color.mainColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.trailing, 4)
            .padding(.top, 3)
            .padding(.bottom, 3)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newMessage = ChatMessage(
            text: messageText,
            isCurrentUser: true,
            timestamp: Date()
        )

        messages.append(newMessage)
        messageText = ""
    }
    
    var afterAssessment: some View {
        VStack {
            Text("[\(username)님과 대화는 어땠나요?]")
                .font(.pixel(12))
            HStack {
                ForEach(0..<buttonTitles.count, id: \.self) { index in
                    assessmentBtn(buttonTitles[index], index)
                }
            }
        }
    }
    
    func assessmentBtn(_ title: String, _ index: Int) -> some View {
        Button(action: {
            
        }, label: {
            Text(title)
                .font(.pixel(12))
                .foregroundStyle(Color.whiteColor)
        })
        .background(buttonColors[index])
    }
    
}


#Preview {
    ChatingView()
}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 16)
            .padding(.trailing, 4)
            .padding(.top, 3)
            .padding(.bottom, 4)
            .frame(height: 43)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.gray0)
        )
        .padding(.vertical)
    }
}
