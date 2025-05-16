//
//  OnboardingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import Foundation
import Combine

@MainActor
class OnboardingViewModel: ObservableObject {
    private var appState = AppState.shared
    let onboardingNetworkManger = OnboardingNetworkManager()
    @Published var genderSelectedIndex: Int = 0
    
    let locationOption = ["서울특별시", "경기도", "강원도", "제주도", "전라남도", "전라북도", "경상남도", "경상북도", "충청남도", "충청북도"]
    let detailLocationOption = ["강남구", "관악구", "도봉구", "은평구", "마포구", "금천구", "동작구", "광진구", "서초구", "양천구"]
    @Published var locationSelectedIndex: Int = 0
    @Published var detailLocationSelectedIndex: Int = 0
    
    @Published var nicknameInput: String = ""
    @Published var birthYear: [String] = ["", "", "", ""]
    @Published var birthMonth: [String] = ["", ""]
    @Published var birthDay: [String] = ["", ""]
    @Published var height: [String] = ["", ""]
    
    var education = ["고등학교", "대학교 재학 중", "대학 졸업", "석사", "박사", "기타"]
    @Published var isEducationButtonSelected: [Bool] = Array(repeating: false, count: 6)
    @Published var selectedEducationIndex: Int? = nil
    @Published var schoolName: String = ""
    
    let jobItmes = ["전문직/기업", "연구/교육", "IT/개발", "의료/복지", "디자인/크리에이티브", "미디어/예술", "금융/법률", "영업/서비스", "기술/생산", "은퇴", "아직 학생이에요", "기타"]
    @Published var isJobButtonSelected: [Bool] = Array(repeating: false, count: 12)
    @Published var selectedJobIndex: Int? = nil
    @Published var jobDetail: String = ""
    
    var drunkTexts: [String] = ["언제든지!", "가볍게 즐겨요", "안마셔요"]
    var smokeTexts: [String] = ["흡연자에요", "가끔 피워요", "비흡연자에요"]
    var tattooTexts: [String] = ["있어요", "관심이 있어요", "없어요"]
    var religionTexts: [String] = ["있어요", "관심이 있어요", "없어요"]
    @Published var isDrunkButtonSelected: [Bool] = Array(repeating: false, count: 3)
    @Published var isSmokeButtonSelected: [Bool] = Array(repeating: false, count: 3)
    @Published var isTattooButtonSelected: [Bool] = Array(repeating: false, count: 3)
    @Published var isReligionButtonSelected: [Bool] = Array(repeating: false, count: 3)
    
    func makeBirthDate() -> String {
        return birthYear.joined() + "-" + birthMonth.joined() + "-" + birthDay.joined()
    }
    
    func makeHeight() -> Int {
        return Int(height.joined()) ?? 00
    }
    
    func makeLocation() -> String {
        return locationOption[locationSelectedIndex] + "/" + detailLocationOption[detailLocationSelectedIndex]
    }
    
    func makeJobString() -> String? {
        guard let selectedEducationIndex = selectedEducationIndex else { return nil }
        if jobDetail != "" {
            return education[selectedEducationIndex] + "/" + jobDetail
        } else {
            return education[selectedEducationIndex]
        }
    }
    
    func makeEducationString() -> String? {
        guard let selectedEducationIndex = selectedEducationIndex else { return nil }
        if jobDetail != "" {
            return education[selectedEducationIndex] + "/" + jobDetail
        } else {
            return education[selectedEducationIndex]
        }
    }
    
    func makeSusceptibleString() -> String? {
        guard let drunkIndex = isDrunkButtonSelected.firstIndex(of: true) else { return nil }
        guard let smokeIndex = isSmokeButtonSelected.firstIndex(of: true) else { return nil }
        guard let tattoIndex = isTattooButtonSelected.firstIndex(of: true) else { return nil }
        guard let religionIndex = isReligionButtonSelected.firstIndex(of: true) else { return nil }
        return drunkTexts[drunkIndex] + "/" + smokeTexts[smokeIndex] + "/" + tattooTexts[tattoIndex] + "/" + religionTexts[religionIndex]
    }
    
    func susceptibleInfoCompleteChecking() -> Bool {
        let drunkButtonSelected = isDrunkButtonSelected.contains(true)
        let smokeButtonSelected = isSmokeButtonSelected.contains(true)
        let tattooButtonSelected = isTattooButtonSelected.contains(true)
        let religionButtonSelected = isReligionButtonSelected.contains(true)
        
        return drunkButtonSelected && smokeButtonSelected && tattooButtonSelected && religionButtonSelected
    }
}

//MARK: - 서버 통신 관련
extension OnboardingViewModel {
    // 유저 정보 받아오기
    func getUsersProfileData() async {
        do {
            let result = try await onboardingNetworkManger.fetchOnboardingData()
            switch result {
            case .success(let data):
                print(#fileID, #function, #line, "- data checking: \(data)")
                self.settingProfileData(userProfile: data.data)
                await self.determineStartProfileData(userProfile: data.data)
            case .failure(let error):
                print(#fileID, #function, #line, "- failur: \(error.localizedDescription)")
            }
        } catch {
        }
    }
    
    // 초반에 어떤 뷰로 가야하는지 세팅 -> 초반에 프로필을 입력하다가 나갔을 경우 입력이 안된 페이지 부터 입력해야 하므로 그 화면이 어디인지 판단하는 함수
    // ex) 성별, 닉네임, 생일까지 입력했으면 -> 다시 들어올 때는 키 입력하는 화면으로 이동되어야함
    func determineStartProfileData(userProfile: UserProfile) async {
        if userProfile.gender == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
        } else if userProfile.nickname == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
        } else if userProfile.birthDate == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.birth)
        } else if userProfile.height == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.birth)
            appState.onboardingPath.append(Onboarding.height)
        } else if userProfile.activeRegion == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.birth)
            appState.onboardingPath.append(Onboarding.height)
            appState.onboardingPath.append(Onboarding.locationSelect)
        } else if userProfile.preferenceType == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.birth)
            appState.onboardingPath.append(Onboarding.height)
            appState.onboardingPath.append(Onboarding.locationSelect)
            appState.onboardingPath.append(Onboarding.loveKeyword)
        } else if userProfile.highestEducation == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.birth)
            appState.onboardingPath.append(Onboarding.height)
            appState.onboardingPath.append(Onboarding.locationSelect)
            appState.onboardingPath.append(Onboarding.loveKeyword)
            appState.onboardingPath.append(Onboarding.education)
        } else if userProfile.job == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.birth)
            appState.onboardingPath.append(Onboarding.height)
            appState.onboardingPath.append(Onboarding.locationSelect)
            appState.onboardingPath.append(Onboarding.loveKeyword)
            appState.onboardingPath.append(Onboarding.education)
            appState.onboardingPath.append(Onboarding.job)
        } else if userProfile.sensitiveInfo == nil {
            appState.onboardingPath.append(Onboarding.genderSelect)
            appState.onboardingPath.append(Onboarding.nickname)
            appState.onboardingPath.append(Onboarding.birth)
            appState.onboardingPath.append(Onboarding.height)
            appState.onboardingPath.append(Onboarding.locationSelect)
            appState.onboardingPath.append(Onboarding.loveKeyword)
            appState.onboardingPath.append(Onboarding.education)
            appState.onboardingPath.append(Onboarding.job)
            appState.onboardingPath.append(Onboarding.susceptible)
        }
    }
    
    // 입력된 정보를 세팅하는 부분
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
        if let heightInt = userProfile.height {
            let digits = String(heightInt).compactMap { String($0) }
            height[0] = digits[0]
            height[1] = digits[1]
        }
        if let activeRegion = userProfile.activeRegion {
            let components = activeRegion.components(separatedBy: "/")
        }
        if let preferenceType = userProfile.preferenceType {
            let components = preferenceType.components(separatedBy: "/")
        }
        if let highestEducation = userProfile.highestEducation {
            let components = highestEducation.components(separatedBy: ["(", ")"]).filter { !$0.isEmpty }
            if components.count <= 2 {
                let degree = components[0]
                guard let index = education.firstIndex(of: degree) else { return }
                isEducationButtonSelected[index] = true
                selectedEducationIndex = index
                if components.count == 2 {
                    schoolName = components[1]
                }
            }
        }
        if let job = userProfile.job {
            let components = job.components(separatedBy: "/")
            if components.count == 2 {
                let job = components[0]
                guard let index = jobItmes.firstIndex(of: job) else { return }
                isJobButtonSelected[index] = true
                self.jobDetail = components[1]
            }
        }
        if let sensitiveInfo = userProfile.sensitiveInfo {
            // 이거에 관련해서 명칭 통일 필요
        }
        
    }
    
    // 유저 정보 서버에 업데이트 해주기
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
}
