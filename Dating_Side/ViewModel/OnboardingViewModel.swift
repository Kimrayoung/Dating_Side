//
//  OnboardingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI

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
    @Published var isAfterPreferenceTypeComplete: Bool = false
    
    var education = ["고등학교", "대학교 재학 중", "대학 졸업", "석사", "박사", "기타"]
    @Published var isEducationButtonSelected: [Bool] = Array(repeating: false, count: 6)
    @Published var selectedEducationIndex: Int? = nil
    @Published var schoolName: String = ""
    
    @Published var jobItmes: [String] = []
    @Published var isJobButtonSelected: [Bool] = []
    @Published var selectedJobIndex: Int? = nil
    @Published var jobDetail: String = ""
    
    var lifeStyleList: [String : [String]] = [:]
    @Published var lifeStyleButtonList: [String : [Bool]] = [:]
    
    @Published var introduceText: String = ""
    
    @Published var selectedImage: UIImage?
    @Published var selectedSeconDayImage: UIImage?
    @Published var selectedForthDayImage: UIImage?
    @Published var selectedSixthDayImage: UIImage?
    
    /// birthDay가 하나라도 비어있지 않은지 체크
    func checkBirthdayComplete() -> Bool {
        return birthYear.allSatisfy { !$0.isEmpty } &&
        birthMonth.allSatisfy { !$0.isEmpty } &&
        birthDay.allSatisfy { !$0.isEmpty }
    }
    
    /// height가 하나라도 비어있지 않은지 체크
    func checkHeightComplete() -> Bool {
        return height.allSatisfy { !$0.isEmpty }
    }
    
    func makeBirthDate() -> String {
        return birthYear.joined() + "-" + birthMonth.joined() + "-" + birthDay.joined()
    }
    
    func makeHeight() -> Int {
        return Int(height.joined()) ?? 00
    }
    
    func makeLocation() -> String {
        return locationOption[locationSelectedIndex].addrName + "/" + detailLocationOption[detailLocationSelectedIndex].addrName
    }
    
    func makeLifeStyle() -> LifeStyle? {
        guard let drunkIndex = lifeStyleButtonList["drinking"]?.firstIndex(of: true) else { return nil }
        guard let smokeIndex = lifeStyleButtonList["smoking"]?.firstIndex(of: true) else { return nil }
        guard let tattoIndex = lifeStyleButtonList["tattoo"]?.firstIndex(of: true) else { return nil }
        guard let religionIndex = lifeStyleButtonList["religion"]?.firstIndex(of: true) else { return nil }
        guard let drunkTextOptions = lifeStyleList["drinking"] else { return nil }
        guard let smokeTextOptions = lifeStyleList["smoking"] else { return nil }
        guard let tattoTextOptions = lifeStyleList["tattoo"] else { return nil }
        guard let religionTextOptions = lifeStyleList["religion"] else { return nil }
        return LifeStyle(drinking: drunkTextOptions[drunkIndex], smoking: smokeTextOptions[smokeIndex], tatto: tattoTextOptions[tattoIndex], religion: religionTextOptions[religionIndex])
    }
    
    func susceptibleInfoCompleteChecking() -> Bool {
        guard let drunkButtonSelected = lifeStyleButtonList["drinking"]?.contains(true) else { return false }
        guard let smokeButtonSelected = lifeStyleButtonList["smoking"]?.contains(true) else { return false }
        guard let tattooButtonSelected = lifeStyleButtonList["tattoo"]?.contains(true) else { return false }
        guard let religionButtonSelected = lifeStyleButtonList["religion"]?.contains(true) else { return false }
        
        return drunkButtonSelected && smokeButtonSelected && tattooButtonSelected && religionButtonSelected
    }
    
    func setupBeforePreferenceBindings() {
        $isBeforePreferenceTypesSelected
            .sink { [weak self] newValue in
                guard let self = self else { return }
                let selectedCnt = newValue.filter { $0 == true }.count
                if selectedCnt >= 3 && selectedCnt <= 7 {
                    self.isBeforePreferenceTypeComplete = true
                } else {
                    self.isBeforePreferenceTypeComplete = false
                }
            }
            .store(in: &cancellables)
    }
    
    func setupAfterPreferenceBindings() {
        $isAfterPreferenceTypesSelected
            .sink { [weak self] newValue in
                guard let self = self else { return }
                let selectedCnt = newValue.filter { $0 == true }.count
                if selectedCnt >= 3 && selectedCnt <= 7 {
                    self.isAfterPreferenceTypeComplete = true
                } else {
                    self.isAfterPreferenceTypeComplete = false
                }
            }
            .store(in: &cancellables)
    }
    
    func loadSelectedImage(imageType: ImageType, pickerItem: PhotosPickerItem) {
        pickerItem.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        switch imageType {
                        case .mainProfile:
                            self.selectedImage = image
                        case .secondDay:
                            self.selectedSeconDayImage = image
                        case .forthDay:
                            self.selectedForthDayImage = image
                        case .sixthDay:
                            self.selectedSixthDayImage = image
                        }
                    }
                case .failure(let error):
                    print("load error:", error)
                }
            }
        }
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
            switch result {
            case .success(let lifeStyleResponse):
                lifeStyleResponse.lifeStyleList.forEach({ lifeStyleContent in
                    lifeStyleList[lifeStyleContent.category] = lifeStyleContent.choices
                })
                lifeStyleResponse.lifeStyleList.forEach({ lifeStyleContent in
                    let tempButton = Array(repeating: false, count: lifeStyleContent.choices.count)
                    lifeStyleButtonList[lifeStyleContent.category] = tempButton
                })
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            }
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
    func postUserData(_ socialType: String, _ userSocialID: String) async -> Bool{
        let location = makeLocation()
        let birthDate = makeBirthDate()
        let height = makeHeight()
        guard let selectedEducationIndex = selectedEducationIndex else { return false }
        guard let selectedJobIndex = selectedJobIndex else { return  false }
        
        // 선택된 민감 정보 파악하기
        guard let lifeStyle = makeLifeStyle() else { return false }
        
        guard let selectedImage = selectedImage, let selectedSeconDayImage = selectedSeconDayImage, let selectedForthDayImage = selectedForthDayImage, let selectedSixthDayImage = selectedSixthDayImage else { return false }
        
        let userData = SignupRequest(socialType: socialType, userSocialId: userSocialID, phoneNumber: "", genderType: genderSelectedIndex == 0 ? "여자" : "남자", nickName: nicknameInput, birthDate: birthDate, height: height, activeRegion: location, beforePreferenceTypeList: [], afterPreferenceTypeList: [], edcationType: education[selectedEducationIndex], educationDetail: schoolName, jobType: jobItmes[selectedJobIndex], jobDetail: jobDetail, lifeStyle: lifeStyle, introduction: "", fcmToken: "")
        
        let userImageData: [AccountImage] = [AccountImage(imageTitle: "profileImage", image: selectedImage), AccountImage(imageTitle: "profileImageDaySecond", image: selectedSeconDayImage), AccountImage(imageTitle: "profileImageDayFourth", image: selectedForthDayImage), AccountImage(imageTitle: "profileImageDaySixth", image: selectedSixthDayImage)]
        
        let signupData = userData.toMultipartFormBuilder(images: userImageData)
        
        guard let signupData = signupData else { return false }
        
        do {
            let result = try await AccountNetworkManager().postUserData(signupData: signupData)
            switch result {
            case .success(let result):
                print(#fileID, #function, #line, "- data checking: \(result.result)")
                return result.result
            case .failure(let error):
                print(#fileID, #function, #line, "- failur: \(error.localizedDescription)")
                return false
            }
        } catch {
            print(#fileID, #function, #line, "- errlr")
            return false
        }
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
