//
//  ChatMessageComponent.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/26.
//

import SwiftUI

struct ChatingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = ChatViewModel(roomId: "1234") // 실제 서버로 교체

    let buttonTitles: [String] = ["아주 좋아요", "좋아요", "보통이에요", "별로에요", "최악이에요"]
    let buttonColors: [Color] = [.mainColor, .subColor2, .gray01, .gray2, .gray3]

    @State private var username: String = "user"
    @State private var showTimestamps = false
    @State private var messageText = ""
    @State private var showProfile: Bool = false
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.messages) { message in
                            MessageRow(
                                message: message,
                                showTimestamp: showTimestamps,
                                showProfile: $showProfile
                            )
                            .id(message.id)
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: vm.messages) { _, newValue in
                    // 마지막 메시지로 스크롤
                    if let last = newValue.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onChanged { value in
                        if value.translation.width < -30 {
                            withAnimation { showTimestamps = true }
                        }
                    }
                    .onEnded { _ in
                        withAnimation { showTimestamps = false }
                    }
            )

            sendTextField
        }
        .onAppear { vm.connect() }
        .onDisappear { vm.disconnect() }
        .onTapGesture { UIApplication.shared.hideKeyboard() }
        .sheet(isPresented: $showProfile) {
            PartnerProfileView(profileShow: $showProfile, needMathcingRequest: false)
                .presentationDetents([.fraction(0.99)])
                .presentationCornerRadius(10)
                .presentationDragIndicator(.visible)
        }
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
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        let userID = UserDefaults.standard.integer(forKey: "userId")
        vm.send(content: text, sender: userID)   // 0 = 나
        messageText = ""
    }

    // (옵션) 하단 만족도 영역 – 필요 시 원하는 곳에 배치
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
            // TODO: 후속 처리
        }) {
            Text(title)
                .font(.pixel(12))
                .foregroundStyle(Color.whiteColor)
        }
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
