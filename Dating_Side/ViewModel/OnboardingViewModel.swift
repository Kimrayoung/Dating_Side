//
//  OnboardingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import Foundation
import Combine

@MainActor
class AccountViewModel: ObservableObject {
    private var appState = AppState.shared
    let onboardingNetworkManger = AccountNetworkManager()
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
extension AccountViewModel {
    // 유저 정보 받아오기
    func getUsersProfileData() async {
        do {
            let result = try await onboardingNetworkManger.fetchUserData()
            switch result {
            case .success(let data):
                print(#fileID, #function, #line, "- data checking: \(data)")
            case .failure(let error):
                print(#fileID, #function, #line, "- failur: \(error.localizedDescription)")
            }
        } catch {
        }
    }
    
    // 유저 정보 저장하기
    func postUserData(_ socialType: String, _ userSocialID: String) async {
        let location = makeLocation()
        let birthDate = makeBirthDate()
        let height = makeHeight()
        guard let selectedEducationIndex = selectedEducationIndex else { return }
        guard let selectedJobIndex = selectedJobIndex else { return }
        
        // 선택된 민감 정보 파악하기
        guard let selectedDrunkIndex = isDrunkButtonSelected.firstIndex(where: { $0 == true }) else { return }
        guard let selectedSmokeIndex = isSmokeButtonSelected.firstIndex(where: { $0 == true }) else { return }
        guard let selectedTattoIndex = isTattooButtonSelected.firstIndex(where: { $0 == true }) else { return }
        guard let selectedReligionIndex = isReligionButtonSelected.firstIndex(where: { $0 == true }) else { return }
        let lifeStyle = LifeStyle(drinking: drunkTexts[selectedDrunkIndex], smoking: smokeTexts[selectedSmokeIndex], tatto: tattooTexts[selectedTattoIndex], religion: religionTexts[selectedReligionIndex])
        
        let userData = SignupRequest(socialType: socialType, userSocialId: userSocialID, phoneNumber: "", genderType: genderSelectedIndex == 0 ? "여자" : "남자", nickName: nicknameInput, birthDate: birthDate, height: height, activeRegion: location, beforePreferenceTypeList: [], afterPreferenceTypeList: [], edcationType: education[selectedEducationIndex], educationDetail: schoolName, jobType: jobItmes[selectedJobIndex], jobDetail: jobDetail, lifeStyle: lifeStyle, introduction: "", fcmToken: "")
    }
    
    // 유저 정보 서버에 업데이트 해주기
    func updateUserProfileData<T>(updateType: UserDataUpdateType, data: T) async -> Bool {
        var newData = UserData(genderType: "", nickName: "", birthDate: "", height: 0, activeRegion: "", beforePreferenceTypeList: [], afterPreferenceTypeList: [], edcationType: "", educationDetail: "", jobType: "", jobDetail: "", lifeStyle: LifeStyle(drinking: "", smoking: "", tatto: "", religion: ""), introduction: "", fcmToken: "")
        
        switch updateType {
        case .gender:
            newData.genderType = data as? String ?? ""
        case .nickname:
            newData.nickName = data as? String ?? ""
        case .birth:
            newData.birthDate = data as? String ?? ""
        case .height:
            newData.height = data as? Int ?? 0
        case .location:
            newData.activeRegion = data as? String ?? ""
        case .loveKeyword:
            newData.beforePreferenceTypeList = data as? [String] ?? []
        case .highestEducation:
            newData.educationDetail = data as? String ?? ""
        case .job:
            newData.jobDetail = data as? String ?? ""
        case .sensitiveInfo:
            newData.lifeStyle = data as? LifeStyle ?? LifeStyle(drinking: "", smoking: "", tatto: "", religion: "")
        case .profileImage:
//            newData. = data as? ProfileImage
            ""
        case .introduction:
            newData.introduction = data as? String ?? ""
        }
        
        do {
            let result = try await onboardingNetworkManger.patchUserData(userData: newData)
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
