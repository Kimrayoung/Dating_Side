//
//  ChatListViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/23.
//

import Foundation
import Logging

final class ChatListViewModel: ObservableObject {
    let loadingManager = LoadingManager.shared
    let attractionNetwork = AttractionNetworkManager()
    let chatNetwork = ChattingNetworkManager()
    
    @Published var timeString: String = "24:00"
    var timer: Timer?
    var totalSeconds: Int = 24 * 60 * 60
    
    func startTimer() {
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
        totalSeconds = 24 * 60 * 60
        updateTimeString()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        guard totalSeconds > 0 else {
            timer?.invalidate()
            timeString = "00:00"
            return
        }
        
        totalSeconds -= 1
        updateTimeString()
    }
    
    private func updateTimeString() {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        timeString = String(format: "%02d:%02d", hours, minutes)
    }
}

extension ChatListViewModel {
    @MainActor
    /// 내게 다가온 사람 조회
    func senderAttraction() async -> [AttractionPartnerData] {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await attractionNetwork.senderAttraction()
            switch result {
            case .success(let userAccount):
                Log.debugPublic("내게 다가온 사람 프로필",userAccount)
                return userAccount.result
            case .failure(let failure):
                Log.debugPublic(failure.localizedDescription)
            }
        } catch {
            Log.debugPublic(error.localizedDescription)
        }
        return []
    }
    
    @MainActor
    /// 내가 다가간 사람 조회
    func receiverAttraction() async -> [AttractionPartnerData] {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await attractionNetwork.receiverAttraction()
            switch result {
            case .success(let userAccount):
                Log.debugPublic("내가 다가간 사람 프로필", userAccount)
                return userAccount.result
            case .failure(let error):
                Log.debugPublic(error.localizedDescription)
            }
        } catch {
            Log.debugPublic(error.localizedDescription)
        }
        return []
    }
    
    @MainActor
    func chattingRoomRequest() async -> ChattingRoomResponse? {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await chatNetwork.chattingRoom()
            switch result {
            case .success(let chattingRomData):
                Log.debugPublic("채팅방 데이터", chattingRomData)
                return chattingRomData
            case .failure(let error):
                Log.errorPublic("채팅 방 데이터 요청 에러", error.localizedDescription)
            }
        } catch {
            Log.errorPublic("채팅 방 데이터 요청 에러", error.localizedDescription)
        }
        return nil
    }
}
