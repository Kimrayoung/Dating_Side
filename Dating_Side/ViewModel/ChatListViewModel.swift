//
//  ChatListViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/23.
//

import Foundation


final class ChatListViewModel: ObservableObject {
    
    let loadingManager = LoadingManager.shared
    let attractionNetwork = AttractionNetworkManager()
    let chatNetwork = ChattingNetworkManager()
    let matchingNetwork = MatchingNetworkManager()
    
    @Published var timeString: String = "24:00"
    
    // 2,4,6일자 별 이미지
    @Published var matchingImage: UserImage?
    
    // 모든 이미지
    @Published var matchingAllImage: [UserImage]?
    
    
    var showGoodByeView: Bool = false
    
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
    
#warning("매칭일자가 7일 미만일시에 하나씩 표시.")
    @MainActor
    func matchingPartnerPhoto() async {
        loadingManager.isLoading = true
        
        defer {
            loadingManager.isLoading = false
        }
        do {
            let result = try await chatNetwork.matchingPartnerPhoto()
            switch result {
            case .success(let userImage):
                Log.debugPublic("매칭 사진", userImage)
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        }  catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
    
#warning("매칭 일자가 7일 이상일 경우에만 표시.")
    @MainActor
    func matchingPartnerAllPhoto() async {
        loadingManager.isLoading = true
        
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await chatNetwork.matchingPartnerAllPhoto()
            switch result {
            case .success(let userimages):
                Log.debugPublic("매칭 사진들", userimages)
                self.matchingAllImage = userimages
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
    
    @MainActor
    func replyGoodbye(score: Int, comment: String) async {
        loadingManager.isLoading = true
        
        defer {
            loadingManager.isLoading = false
        }
        
        let score = PartnerScore(score: score, comment: comment)
        
        do {
            let result = try await matchingNetwork.matchingCancel(score: score)
            switch result {
            case .success:
                Log.debugPublic("답장 성공")
                self.showGoodByeView = false
                
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
    
}
