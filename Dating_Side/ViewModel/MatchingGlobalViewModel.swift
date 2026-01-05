//
//  MatchingGlobalViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 9/13/25.
//

import Foundation

class MatchingGlobalViewModel {
    let loadingManager = LoadingManager.shared
    let matchingNetwork = MatchingGlobalNetworkManager()
    
    @MainActor
    /// 매칭 상태 조회
    func fetchMatchingStatus() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await matchingNetwork.fetchMatchingStatus()
            switch result {
            case .success(let matchStatusData):
                Log.debugPublic("매칭상대 조회 성공",matchStatusData)
                UserDefaults.standard.set(matchStatusData.matchingStatusType.rawValue, forKey: "matchingStatus")
                Log.debugPublic("matchingDate", matchStatusData.timestampDate?.toString())
                UserDefaults.standard.set(matchStatusData.timestampDate?.toString(), forKey: "matchingDate")
                return
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
        UserDefaults.standard.set(MatchingStatusType.UNMATCHED.rawValue, forKey: "matchingStatus")
    }
}
