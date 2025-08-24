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
    func attraction(matchingPartnerAccount: PartnerAccount?) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        guard let matchingPartnerAccount = matchingPartnerAccount else { return }
        let PartnerRequest = PartnerRequest(partnerId: matchingPartnerAccount.id)
        do {
            let result = try await attractionNetwork.attraction(attraction: PartnerRequest)
            switch result {
            case .success:
                Log.debugPublic("result true")
            case .failure(let error):
                Log.debugPublic("result error: \(error.localizedDescription)")
            }
        } catch {
            Log.debugPublic("result error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    /// 매칭 상태 조회
    func fetchMatchingStauts() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await matchingNetwork.fetchMatchingStatus()
            switch result {
            case .success:
                Log.debugPublic("매칭 상태 조회 성공")
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
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
    func matchingCancel(score: Int) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        let score = PartnerScore(socre: score)
        
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
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
        return nil
    }
    
    func matchingPartnerPhoto() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await matchingNetwork.matchingPartnerPhoto()
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
}
