//
//  MatchingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 8/7/25.
//

import Combine

class MatchingViewModel: ObservableObject {
    let loadingManager = LoadingManager.shared
    var attractionNetwork = AttractionNetworkManager()
    
}

extension MatchingViewModel {
    /// 내가 다가가기
    func attraction(partnerId: Int) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        let attractionRequest = AttractionRequest(partnerId: partnerId)
        do {
            let result = await attractionNetwork.attraction(attraction: attractionRequest)
            switch result {
            case .success:
                Log.debugPublic("result true")
            case .failure(let error):
                Log.debugPublic("result error: \(error.localizedDescription)")
            }
        }
    }
    
    /// 내게 다가온 사람 조회
    func senderAttraction() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = await attractionNetwork.senderAttraction()
            switch result {
            case .success(let userAccount):
                Log.debugPublic("내게 다가온 사람 프로필", userAccount)
            case .failure(let failure):
                Log.debugPublic(failure.localizedDescription)
            }
        }
    }
    
    /// 내가 다가간 사람 조회
    func receiverAttraction() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = await attractionNetwork.receiverAttraction()
            switch result {
            case .success(let userAccount):
                Log.debugPublic("내가 다가간 사람 프로필", userAccount)
            case .failure(let error):
                Log.debugPublic(error.localizedDescription)
            }
        }
    }
}
