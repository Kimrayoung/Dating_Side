//
//  ChatViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 8/24/25.
//

import Foundation


@MainActor
final class ChatViewModel: ObservableObject {
    
    let chatNetwork = ChattingNetworkManager()
    let matchingNetwork = MatchingNetworkManager()
    let loadingManager = LoadingManager.shared
    private var appState = AppState.shared
    
    @Published var messages: [ChatMessage] = []
    @Published var isConnected = false
    @Published var connectionStatus: String = "연결 대기 중..."
    @Published var showGoodByeView: Bool = false
    
    
    private let client: WebSocketClient
    private var listenTask: Task<Void, Never>?
    private let roomId: String
    private let jwt: String
    
    init(roomId: String) {
        self.roomId = roomId
        let accessToken = KeychainManager.shared.getAccessToken()
        self.jwt = accessToken ?? ""
        self.client = WebSocketClient(endpoint: "wss://donvolo.shop/api/chat", jwt: accessToken, roomId: roomId)
    }
    
    deinit {
        listenTask?.cancel()
    }
    
    func connect() {
        guard listenTask == nil else { return } // 이미 연결 중이면 무시
        
        connectionStatus = "연결 중..."
        Log.debugPublic("connectionStatus",connectionStatus)
        
        loadingManager.isLoading = true
        
        listenTask = Task {
            do {
                await client.connect(jwt: jwt)
                await client.waitUntilStompConnected()
                connectionStatus = "구독 중..."
                
                // STOMP 연결 완료 대기 시간 단축
                try await Task.sleep(nanoseconds: 200_000_000) // 0.2초
                await client.subscribe(roomId: roomId)
                
                isConnected = true
                connectionStatus = "연결됨"
                
                loadingManager.isLoading = false
                
                for await msg in await client.messages {
                    messages.append(msg)
                }
                
            } catch {
                print("❌ Connection failed: \(error)")
                connectionStatus = "연결 실패: \(error.localizedDescription)"
                
                loadingManager.isLoading = false
            }
            
            isConnected = false
            connectionStatus = "연결 끊김"
        }
    }
    
    func send(content: String) {
        guard isConnected else {
            print("⚠️ Cannot send message: not connected")
            return
        }
        
        let chat = SocketMessage(content: content, roomId: roomId)
        
        Task {
            do {
                print("📤 About to call client.sendMessage...")
                try await client.sendMessage(chat)
                print("📤 client.sendMessage completed")
            } catch {
                print("❌ Send failed: \(error)")
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
    
    @MainActor
    func fetchChattingData() async {
        loadingManager.isLoading = true
        
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await chatNetwork.chatting()
            switch result {
            case .success(let chatData):
                Log.debugPublic("채팅 기록", chatData)
                messages.append(contentsOf: chatData)
            case .failure(let error):
                Log.errorPublic("채팅 방 데이터 요청 에러", error.localizedDescription)
            }
        } catch {
            Log.errorPublic("채팅 방 데이터 요청 에러", error.localizedDescription)
        }
    }
    
    //MARK: - 헤어지기
    func leaveChatting(score: Int, comment: String) async {
        loadingManager.isLoading = true
        
        defer {
            loadingManager.isLoading = false
        }
        
        let score = PartnerScore(score: score, comment: comment)
        
        do {
            let result = try await matchingNetwork.matchingCancel(score: score)
            switch result {
            case .success:
                Log.debugPublic("헤어지기 성공")
                self.showGoodByeView = false
                appState.chatPath.removeLast()
                
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
    
    //MARK: - 신고하기
    func userReport(reason: String){
        loadingManager.isLoading = true
        
        defer {
            loadingManager.isLoading = false
        }
        let reason = ReportRequest(reason: reason)
        
        Task{
            do{
                let result = try await chatNetwork.userReport(report: reason)
                switch result {
                case .success:
                    Log.debugPublic("신고하기 성공")
                    appState.chatPath.removeLast()
                    await leaveChatting(score: 1, comment: reason.reason)
                case .failure(let error):
                    Log.errorPublic(error.localizedDescription)
                }
            }catch{
                Log.debugPublic(error.localizedDescription)
            }
        }
    }
    
}
