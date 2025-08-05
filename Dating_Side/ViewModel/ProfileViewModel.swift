//
//  ProflieViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/26.
//

import Foundation

class ProfileViewModel: ObservableObject {
    let loadingManager = LoadingManager.shared
    let profileNetworkManager = ProfileNetworkManager()
    @Published var valueList: [String] = []
    @Published var userData: UserAccount? = nil
    @Published var userValueList: [String : [String]] = [:]
    
    /// 이름/나이/키
    func makeSimpleProfile() -> String{
        guard let userData = userData else { return "" }
        let birthYear = userData.birthDate.components(separatedBy: "-").first ?? ""
        return "\(userData.nickName)/\(birthYear)/1\(userData.height)cm"
    }
    
    func makeSchoolString() -> String {
        guard let userData = userData else { return "" }
        
        return "\(userData.educationType), \(userData.educationDetail)"
    }
    
    func makeJobString() -> String{
        guard let userData = userData else { return "" }
        
        return "\(userData.jobType), \(userData.jobDetail)"
    }
}

extension ProfileViewModel {
    /// 유저 정보 가져오기
    @MainActor
    func fetchUserAccountData() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        do {
            let result = try await profileNetworkManager.fetchUserAccount()
            
            switch result {
            case .success(let userData):
                self.userData = userData
                Log.debugPrivate("유저 정보: ", userData)
                
            case .failure(let error):
                Log.errorPublic("유저 정보 가져오기 오류", error.localizedDescription)
            }
        } catch {
            Log.errorPublic("유저 정보 가져오기 오류", error.localizedDescription)
        }
    }
    
    /// 유저의 답변리스트 가져오기
    @MainActor
    func fetchUserAnswerList() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        do {
            let result = try await profileNetworkManager.getUserAnswerList()
            
            switch result {
            case .success(let userAnswerList):
                userAnswerList.profileList.forEach { profile in
                    userValueList[profile.category] = profile.contentList
                }
                Log.debugPublic("유저 가치관 정보: ", userAnswerList)
            case .failure(let error):
                Log.errorPublic("유저 가치관 정보 가져오기 오류", error.localizedDescription)
            }
        } catch {
            Log.errorPublic("유저 가치관 정보 가져오기 오류", error.localizedDescription)
        }
    }
}
