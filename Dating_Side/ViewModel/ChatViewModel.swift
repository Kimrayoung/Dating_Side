//
//  ChatViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 8/24/25.
//

import Foundation
import Combine

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
    
    
    private let roomId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(roomId: String) {
        self.roomId = roomId
        SocketSubscriber()
    }
    
    //실시간 채팅 구독
    private func SocketSubscriber() {
        WebSocketManager.shared.messageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newMsg in
                self?.messages.append(newMsg)
                
                Task{
                    await self?.fetchChattingData()
                }
            }
            .store(in: &cancellables)
    }
    
    func send(content: String) {
        WebSocketManager.shared.send(content: content, roomId: roomId)
    }
    
    //MARK: - 모든 내용 확인하기
    @MainActor
    func fetchChattingData() async {
        do {
            let result = try await chatNetwork.chatting()
            switch result {
            case .success(let chatData):
                self.messages = chatData
                
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
                WebSocketManager.shared.disconnect()
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
                    await leaveChatting(score: 1, comment: reason.reason) //신고할 정도면 1점이 맞지 ㄹㅇㅋㅋ
                    WebSocketManager.shared.disconnect()
                case .failure(let error):
                    Log.errorPublic(error.localizedDescription)
                }
            }catch{
                Log.debugPublic(error.localizedDescription)
            }
        }
    }
    
}
