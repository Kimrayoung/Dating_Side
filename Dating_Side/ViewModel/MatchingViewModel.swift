//
//  MatchingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 8/7/25.
//

import Combine


/// 매칭 및 매칭 상대 확인
final class MatchingViewModel: ObservableObject {
    let loadingManager = LoadingManager.shared
    let attractionNetwork = AttractionNetworkManager()
    let matchingNetwork = MatchingNetworkManager()
    
    func makeSimpleProfile(matchingPartnerAccount: PartnerAccount?) -> String{
        guard let userData = matchingPartnerAccount else { return "" }
        return "\(userData.nickName)/\(userData.birthYear)/\(userData.height)cm"
    }
    
    func makeSchoolString(matchingPartnerAccount: PartnerAccount?) -> String {
        guard let userData = matchingPartnerAccount else { return "" }
        if userData.educationDetail == "" {
            return "\(userData.educationType)"
        } else {
            return "\(userData.educationType), \(userData.educationDetail)"
        }
        
    }
    
    func makeJobString(matchingPartnerAccount: PartnerAccount?) -> String{
        guard let userData = matchingPartnerAccount else { return "" }
        
        if userData.jobDetail == "" {
            return "\(userData.jobType), \(userData.jobDetail)"
        } else {
            return "\(userData.jobType), \(userData.jobDetail)"
        }
    }
    
}


extension MatchingViewModel {
    /// 내가 다가가기
    @MainActor
    func attraction(matchingPartnerAccount: PartnerAccount?) async -> Bool {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        guard let matchingPartnerAccount = matchingPartnerAccount else { return false }
        let PartnerRequest = PartnerRequest(partnerId: matchingPartnerAccount.id)
        do {
            let result = try await attractionNetwork.attraction(attraction: PartnerRequest)
            switch result {
            case .success:
                Log.debugPublic("result true")
                return true
            case .failure(let error):
                Log.debugPublic("result error: \(error.localizedDescription)")
            }
        } catch {
            Log.debugPublic("result error: \(error.localizedDescription)")
        }
        return false
    }
    
    
    
    /// 매칭 요청 -> 매칭 시도(프로필 완성 뷰)
    @MainActor
    func matchingRequest() async -> PartnerAccount? {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await matchingNetwork.matchingRequest()
            switch result {
            case .success(let partnerData):
                Log.debugPublic("매칭 요청 성공", partnerData.result)
                return partnerData.result
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
        return nil
    }
    
    /// 매칭 취소
    @MainActor
    func matchingCancel(score: Int, comment: String) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        let score = PartnerScore(socre: score, comment: comment)
        
        print(score.socre, score.comment)
        
        do {
            let result = try await matchingNetwork.matchingCancel(score: score)
            switch result {
            case .success:
                Log.debugPublic("매칭 삭제 성공")
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
    
    /// 매칭 확정
    @MainActor
    func matchingComplete(partnerId: Int) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        let partnerId = PartnerRequest(partnerId: partnerId)
        do {
            let result = try await matchingNetwork.matchingComplete(partner: partnerId)
            switch result {
            case .success:
                Log.debugPublic("매칭 삭제 성공")
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
    
    @MainActor
    /// 매칭 상대 조회
    func matchingPartner() async -> PartnerAccount? {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await matchingNetwork.matchingPartner()
            switch result {
            case .success(let userAccount):
                Log.debugPublic("매칭 요청 성공", userAccount)
                return userAccount.result
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
        return nil
    }

}
