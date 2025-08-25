//
//  ChatViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 8/24/25.
//

import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isConnected = false
    @Published var connectionStatus: String = "연결 대기 중..."

    private let client: WebSocketClient
    private var listenTask: Task<Void, Never>?
    private let roomId: String
    private let jwt: String

    init(roomId: String) {
        self.roomId = roomId
        let accessToken = KeychainManager.shared.getAccessToken()
        self.jwt = accessToken ?? ""
        self.client = WebSocketClient(endpoint: "wss://donvolo.shop/api/chat", jwt: accessToken)
    }

    func connect() {
        guard listenTask == nil else { return } // 이미 연결 중이면 무시
        
        connectionStatus = "연결 중..."
        
        listenTask = Task {
            do {
                await client.connect(jwt: jwt)
                connectionStatus = "구독 중..."
                
                // STOMP 연결 완료 대기 시간 단축
                try await Task.sleep(nanoseconds: 200_000_000) // 0.2초
                await client.subscribe(roomId: roomId)
                
                isConnected = true
                connectionStatus = "연결됨"
                
                // 메시지 수신 루프
                for await msg in await client.messages {
                    messages.append(msg)
                }
                
            } catch {
                print("❌ Connection failed: \(error)")
                connectionStatus = "연결 실패: \(error.localizedDescription)"
            }
            
            isConnected = false
            connectionStatus = "연결 끊김"
        }
    }

    func send(content: String, sender: Int) {
        guard isConnected else {
            print("⚠️ Cannot send message: not connected")
            return
        }
        
        let chat = ChatMessage(content: content, sender: sender, timestamp: Date())
        
        // 즉시 UI에 추가 (optimistic update)
        messages.append(chat)
        
        Task {
            do {
                try await client.sendMessage(chat, roomId: roomId)
            } catch {
                print("❌ Send failed: \(error)")
                // 전송 실패 시 메시지 제거 또는 실패 표시
                if let index = messages.firstIndex(where: { $0.id == chat.id }) {
                    messages.remove(at: index)
                }
            }
        }
    }

    func disconnect() {
        listenTask?.cancel()
        listenTask = nil
        
        Task {
            await client.disconnect()
        }
        
        isConnected = false
        connectionStatus = "연결 종료"
    }
    
    deinit {
        listenTask?.cancel()
    }
}
