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
    let accountNetworkManger = AccountNetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    var socialType: SocialType? = nil
    var socialId: String? = nil
    @Published var genderSelectedIndex: Int = 0
    
    @Published var locationOption: [Address] = []
    @Published var detailLocationOption: [Address] = []
    @Published var locationSelectedIndex: Int = 0
    @Published var detailLocationSelectedIndex: Int = 0
    
    @Published var nicknameInput: String = ""
    @Published var birthYear: [String] = ["", "", "", ""]
    @Published var birthMonth: [String] = ["", ""]
    @Published var birthDay: [String] = ["", ""]
    @Published var height: [String] = ["", ""]
    
    @Published var beforePreferenceTypes: [String] = []
    @Published var afterPreferceTypes: [String] = []
    
    @Published var isBeforePreferenceTypesSelected: [Bool] = []
    @Published var isAfterPreferenceTypesSelected: [Bool] = []
    @Published var isBeforePreferenceTypeComplete: Bool = false
    
    var education = ["고등학교", "대학교 재학 중", "대학 졸업", "석사", "박사", "기타"]
    @Published var isEducationButtonSelected: [Bool] = Array(repeating: false, count: 6)
    @Published var selectedEducationIndex: Int? = nil
    @Published var schoolName: String = ""
    
    @Published var jobItmes: [String] = []
    @Published var isJobButtonSelected: [Bool] = []
    @Published var selectedJobIndex: Int? = nil
    @Published var jobDetail: String = ""
    
    @Published var drunkTexts: [String] = ["언제든지!", "가볍게 즐겨요", "안마셔요"]
    @Published var smokeTexts: [String] = ["흡연자에요", "가끔 피워요", "비흡연자에요"]
    @Published var tattooTexts: [String] = ["있어요", "관심이 있어요", "없어요"]
    @Published var religionTexts: [String] = ["있어요", "관심이 있어요", "없어요"]
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
        return locationOption[locationSelectedIndex].addrName + "/" + detailLocationOption[detailLocationSelectedIndex].addrName
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
    
    func setupBeforePreferenceBindings() {
        $isBeforePreferenceTypesSelected
            .sink { [weak self] newValue in
                guard let self = self else { return }
                let selectedCnt = newValue.filter { $0 == true }.count
                if selectedCnt >= 3 && selectedCnt <= 7 {
                    self.isBeforePreferenceTypeComplete.toggle()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - 서버 통신 관련
extension AccountViewModel {
    func fetchAddressData(isFirstLoading: Bool = false, code: String? = nil, isDetailLocation: Bool = false) async {
        do {
            let result = try await accountNetworkManger.fetchAddressData(code)
            switch result {
            case .success(let data):
                if isDetailLocation {
                    self.detailLocationOption = data
                } else {
                    self.locationOption = data
                }
                
                print(#fileID, #function, #line, "- self.locationOption: \(self.locationOption )")
                if isFirstLoading {
                    guard let firstLocationData = data.first else { return }
                    print(#fileID, #function, #line, "- firstLocation: \(firstLocationData)")
                    await self.fetchAddressData(isFirstLoading: false, code: firstLocationData.code, isDetailLocation: true)
                }
            case .failure(let error):
                print(#fileID, #function, #line, "- failur: \(error.localizedDescription)")
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
        }
    }
    
    func fetchPreferenceType(preferenceType: PreferenceType) async {
        do {
            let result = try await accountNetworkManger.fetchPreferenceType(preferenceType.rawValue)
            switch result {
            case .success(let data):
                switch preferenceType {
                case .before:
                    beforePreferenceTypes = data
                    isBeforePreferenceTypesSelected = Array(repeating: false, count: data.count)
                    print(#fileID, #function, #line, "- preference data: \(data)")
                case .after:
                    afterPreferceTypes = data
                    isAfterPreferenceTypesSelected = Array(repeating: false, count: data.count)
                }
                
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
        }
    }
    
    func fetchJobType() async {
        do {
            let result = try await accountNetworkManger.fetchJobType()
            switch result {
            case .success(let data):
                jobItmes = data
                isJobButtonSelected = Array(repeating: false, count: data.count)
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
        }
    }
    
    func fetchLifeStyle() async {
        do {
            let result = try await accountNetworkManger.fetchLifeStyleDatas()
            
        } catch {
            
        }
    }
    
    // 유저 정보 받아오기
    func getUsersProfileData() async {
        do {
            let result = try await accountNetworkManger.fetchUserData()
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
            let result = try await accountNetworkManger.patchUserData(userData: newData)
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
