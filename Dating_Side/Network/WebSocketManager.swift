//
//  WebSocketManager.swift
//  Dating_Side
//
//  Created by 안세훈 on 2/9/26.
//

import Foundation
import Combine

class WebSocketManager: ObservableObject {
    static let shared = WebSocketManager()
    private var client: WebSocketClient?
    
    let messageSubject = PassthroughSubject<ChatMessage, Never>()
    
    private init() { }
    
    func connect(jwt: String, roomId: String) {
        if client != nil { return }
        client = WebSocketClient(endpoint: "wss://donvolo.shop/api/chat", jwt: jwt, roomId: roomId)
        
        Task {
            await client?.connect(jwt: jwt)
            await client?.waitUntilStompConnected()
            await client?.subscribe(roomId: roomId)
            
            if let messagesStream = await client?.messages {
                for await msg in messagesStream {
                    await MainActor.run {
                        self.messageSubject.send(msg)
                        
                        NotificationCenter.default.post(
                            name: NSNotification.Name("NewChatMessageReceived"),
                            object: nil
                        )
                    }
                }
            }
        }
    }
    
    func send(content: String, roomId: String) {
        let message = SocketMessage(content: content, roomId: roomId)
        Task {
            try? await client?.sendMessage(message)
        }
    }
    
    func disconnect() {
        Task { await client?.disconnect() }
        client = nil
    }
}
