//
//  OnboardingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OnboardingViewModel: ObservableObject {
    private var appState = AppState.shared
    let onboardingNetworkManger = OnboardingNetworkManager()
    @Published var genderSelectedIndex: Int = 0
    @Published var locationSelectedIndex: Int = 0
    @Published var detailLocationSelectedIndex: Int = 0
    @Published var nicknameInput: String = ""
    @Published var birthYear: [String] = ["", "", "", ""]
    @Published var birthMonth: [String] = ["", ""]
    @Published var birthDay: [String] = ["", ""]
    @Published var height: [String] = ["", ""]
    @Published var isEducationButtonSelected: [Bool] = Array(repeating: false, count: 6)
    @Published var selectedEducationIndex: Int? = nil
    @Published var schoolName: String = ""
    @Published var isJobButtonSelected: [Bool] = Array(repeating: false, count: 12)
    @Published var jobDetail: String = ""
    @Published var isDrunkButtonSelected: [Bool] = Array(repeating: false, count: 3)
    @Published var isSmokeButtonSelected: [Bool] = Array(repeating: false, count: 3)
    @Published var isTattooButtonSelected: [Bool] = Array(repeating: false, count: 3)
    @Published var isReligionButtonSelected: [Bool] = Array(repeating: false, count: 3)
    
    
    
    func getUsersProfileData() async {
        do {
            let result = try await onboardingNetworkManger.fetchOnboardingData()
            switch result {
            case .success(let data):
                print(#fileID, #function, #line, "- data checking: \(data)")
                await self.determineStartProfileData(userProfile: data.data)
                self.settingProfileData(userProfile: data.data)
            case .failure(let error):
                print(#fileID, #function, #line, "- failur: \(error.localizedDescription)")
            }
        } catch {
        }
    }
    
    func determineStartProfileData(userProfile: UserProfile) async {
        if userProfile.gender == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
        } else if userProfile.nickname == nil {
            appState.onboardingPath = NavigationPath([Onboarding.genderSelect])
            appState.onboardingPath.append(Onboarding.nickname)
        } else if userProfile.height == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.height)
        }
    }
    
    func settingProfileData(userProfile: UserProfile) {
        if let gender = userProfile.gender {
            genderSelectedIndex = gender == "M" ? 1 : 0
        }
        if let nickname = userProfile.nickname {
            nicknameInput = nickname
        }
        if let birthDate = userProfile.birthDate {
            let components = birthDate.components(separatedBy: "-")
            let splitComponent = components.map { component in
                component.map { String($0) }
            }
            birthYear = splitComponent[0]
            birthMonth = splitComponent[1]
            birthDay = splitComponent[2]
        }
    }
    
    func updateUserProfileData<T>(updateType: OnboardingUpdateType, data: T) async -> Bool {
        var newData = UserProfile(gender: nil, activeRegion: nil, preferenceType: nil, nickname: nil, birthDate: nil, height: nil, highestEducation: nil, job: nil, sensitiveInfo: nil, profileImage: nil, introduction: nil, createdAt: nil, updatedAt: nil)
        
        switch updateType {
        case .gender:
            newData.gender = data as? String
        case .nickname:
            newData.nickname = data as? String
        case .birth:
            newData.birthDate = data as? String
        case .height:
            newData.height = data as? Int
        case .location:
            newData.activeRegion = data as? String
        case .loveKeyword:
            newData.preferenceType = data as? String
        case .highestEducation:
            newData.highestEducation = data as? String
        case .job:
            newData.job = data as? String
        case .sensitiveInfo:
            newData.sensitiveInfo = data as? SensitiveInfo
        case .profileImage:
            newData.profileImage = data as? ProfileImage
        case .introduction:
            newData.introduction = data as? String
        }
        
        do {
            let result = try await onboardingNetworkManger.patchOnboardingData(userProfileData: newData)
            switch result {
            case .success(let check):
                print(#fileID, #function, #line, "- check: \(check)")
                return check.result
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            }
        } catch {
            
        }
        return false
    }
    
    
    func susceptibleInfoCompleteChecking() -> Bool {
        let drunkButtonSelected = isDrunkButtonSelected.contains(true)
        let smokeButtonSelected = isSmokeButtonSelected.contains(true)
        let tattooButtonSelected = isTattooButtonSelected.contains(true)
        let religionButtonSelected = isReligionButtonSelected.contains(true)
        
        return drunkButtonSelected && smokeButtonSelected && tattooButtonSelected && religionButtonSelected
    }
}
