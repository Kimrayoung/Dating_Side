//
//  AccountViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI


@MainActor
final class AccountViewModel: ObservableObject {
    //MARK: - Data
    private var appState = AppState.shared
    let accountNetworkManger = AccountNetworkManager()
    private var cancellables = Set<AnyCancellable>()
    let loadingManager = LoadingManager.shared
    
    var isOnboarding: AccountType = .onboarding
    var socialType: SocialType? = nil
    var socialId: String? = nil
    
    @Published var genderSelectedIndex: Int = 0
    
    @Published var locationOption: [Address] = []
    @Published var locationSelected: Address? = nil
    @Published var detailLocationOption: [Address] = []
    @Published var detailLocationSelected: Address? = nil
    
    @Published var nicknameInput: String = ""
    @Published var birthYear: [String] = ["", "", "", ""]
    @Published var birthMonth: [String] = ["", ""]
    @Published var birthDay: [String] = ["", ""]
    @Published var height: [String] = ["", ""]
    
    @Published var beforePreferenceTypes: [KoreanData] = []
    @Published var afterPreferceTypes: [KoreanData] = []
    
    @Published var isBeforePreferenceTypesSelected: [Bool] = []
    @Published var isAfterPreferenceTypesSelected: [Bool] = []
    @Published var isBeforePreferenceTypeComplete: Bool = false
    @Published var isAfterPreferenceTypeComplete: Bool = false
    
//    var education = ["고등학교", "대학교 재학 중", "대학 졸업", "석사", "박사", "기타"]
    var education: [EducationEnglish] = EducationEnglish.allCases
    @Published var isEducationButtonSelected: [Bool] = Array(repeating: false, count: 6)
    @Published var selectedEducationIndex: Int? = nil
    @Published var schoolName: String = ""
    
    @Published var jobItmes: [KoreanData] = []
    @Published var isJobButtonSelected: [Bool] = []
    @Published var selectedJobIndex: Int? = nil
    @Published var jobDetail: String = ""
    
    var lifeStyleOriginalList: [String : [KoreanData]] = [:]
    var lifeStyleList: [String: [String]] = [:]
    @Published var lifeStyleButtonList: [String : [Bool]] = [:]
    
    @Published var introduceText: String = ""
    
    @Published var selectedImage: UIImage?
    @Published var selectedSeconDayImage: UIImage?
    @Published var selectedForthDayImage: UIImage?
    @Published var selectedSixthDayImage: UIImage?
    
    //MARK: - 공통 사용(회원 등록, 회원 수정)
    
    func checkLocationData() -> Bool {
        return locationSelected != nil && detailLocationSelected != nil ? true : false
    }
    
    /// 위치 정보 만들기
    func makeLocation() -> String {
        guard let locationSelected = locationSelected, let detailLocationSelected = detailLocationSelected else { return "" }
        return locationSelected.addrName + "/" + detailLocationSelected.addrName
    }
    
    func setEducation(selectedEducation: String?) {
        if let selectedEducation = selectedEducation {
            isEducationButtonSelected = education.map { selectedEducation.contains($0.korean)}
            selectedEducationIndex = isEducationButtonSelected.firstIndex(of: true)
        }
    }
    
    func makeEducationType() -> EducationEnglish? {
        guard let selectedEducationIndex = selectedEducationIndex else { return nil }
        
        if education.indices.contains(selectedEducationIndex) {
            return education[selectedEducationIndex]
        } else {
            return nil
        }
    }
    
    func makeJobType() -> KoreanData? {
        guard let selectedJobIndex = selectedJobIndex else { return  nil }
        
        if jobItmes.indices.contains(selectedJobIndex) {
            return jobItmes[selectedJobIndex]
        } else {
            return nil
        }
    }
    
    func makeBeforePreference() -> [String] {
        return zip(beforePreferenceTypes, isBeforePreferenceTypesSelected)
            .compactMap { (type, isSelected) in
                isSelected ? type.type : nil
            }
    }
    
    func makeAfterPreference() -> [String] {
        return zip(afterPreferceTypes, isAfterPreferenceTypesSelected)
            .compactMap { (type, isSelected) in
                isSelected ? type.type : nil
            }
    }
    
    /// 민감정보 만들기
    func makeLifeStyle(needKorean: Bool = false) -> LifeStyle? {
        guard let drunkIndex = lifeStyleButtonList["drinking"]?.firstIndex(of: true) else { return nil }
        guard let smokeIndex = lifeStyleButtonList["smoking"]?.firstIndex(of: true) else { return nil }
        guard let tattoIndex = lifeStyleButtonList["tattoo"]?.firstIndex(of: true) else { return nil }
        guard let religionIndex = lifeStyleButtonList["religion"]?.firstIndex(of: true) else { return nil }
        guard let drunkTextOptions = lifeStyleOriginalList["drinking"] else { return nil }
        guard let smokeTextOptions = lifeStyleOriginalList["smoking"] else { return nil }
        guard let tattoTextOptions = lifeStyleOriginalList["tattoo"] else { return nil }
        guard let religionTextOptions = lifeStyleOriginalList["religion"] else { return nil }
        
        if needKorean {
            return LifeStyle(drinking: drunkTextOptions[drunkIndex].korean, smoking: smokeTextOptions[smokeIndex].korean, tattoo: tattoTextOptions[tattoIndex].korean, religion: religionTextOptions[religionIndex].korean)
        } else {
            return LifeStyle(drinking: drunkTextOptions[drunkIndex].type, smoking: smokeTextOptions[smokeIndex].type, tattoo: tattoTextOptions[tattoIndex].type, religion: religionTextOptions[religionIndex].type)
        }
        
    }
    
    /// 민감정보들이 전부 선택되었는지 확인
    func susceptibleInfoCompleteChecking() -> Bool {
        guard let drunkButtonSelected = lifeStyleButtonList["drinking"]?.contains(true) else { return false }
        guard let smokeButtonSelected = lifeStyleButtonList["smoking"]?.contains(true) else { return false }
        guard let tattooButtonSelected = lifeStyleButtonList["tattoo"]?.contains(true) else { return false }
        guard let religionButtonSelected = lifeStyleButtonList["religion"]?.contains(true) else { return false }
        
        return drunkButtonSelected && smokeButtonSelected && tattooButtonSelected && religionButtonSelected
    }
    
    /// 선호 키워드가 3~7으로 선택되었는지 확인
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
    
    /// 선호 키워드가 3~7으로 선택되었는지 확인
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
    
    /// 선택한 이미지 viewModel에 저장
    @MainActor
    func loadSelectedImage(imageType: ImageType, pickerItem: [PhotosPickerItem]) async {
        var result: [UIImage] = []
        result.reserveCapacity(pickerItem.count)
        
        for item in pickerItem {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    // 압축/리사이즈 (예: 1024px, quality 0.2)
                    let reducedImage: UIImage
                    if let resizedData = image.resizedAndCompressedJPEGData(toWidth: 1024, quality: 0.2),
                       let resized = UIImage(data: resizedData) {
                        reducedImage = resized
                    } else {
                        reducedImage = image
                    }
                    result.append(reducedImage)
                }
            } catch {
                print("load error:", error)
            }
        }
        
        switch imageType {
        case .mainProfile:
            self.selectedImage = result.first
        case .secondDay:
            self.selectedSeconDayImage = result.first
        case .forthDay:
            self.selectedForthDayImage = result.first
        case .sixthDay:
            self.selectedSixthDayImage = result.first
        case .additionalImageEdit:
            for (index, image) in result.enumerated() {
                if index == 0 {
                    self.selectedSeconDayImage = image
                } else if index == 1{
                    self.selectedForthDayImage = image
                } else if index == 2 {
                    self.selectedSixthDayImage = image
                }
            }
        } // imageType
    }
}

//MARK: - 프로필 등록일떄만 사용
extension AccountViewModel {
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
    
    /// 생일정보 만들기
    func makeBirthDate() -> String {
        return birthYear.joined() + "-" + birthMonth.joined() + "-" + birthDay.joined()
    }
    
    /// 키 정보 만들기
    func makeHeight() -> Int {
        return Int(height.joined()) ?? 00
    }
    
    /// singup API에 보낼 이미지(유저 이미지)
    func makeSignupImage() -> [AccountImage]? {
        guard let selectedImage = selectedImage, let selectedSeconDayImage = selectedSeconDayImage, let selectedForthDayImage = selectedForthDayImage, let selectedSixthDayImage = selectedSixthDayImage else { return nil }
        
        let userImageData: [AccountImage] = [AccountImage(imageTitle: "profileImage", image: selectedImage), AccountImage(imageTitle: "profileImageDaySecond", image: selectedSeconDayImage), AccountImage(imageTitle: "profileImageDayFourth", image: selectedForthDayImage), AccountImage(imageTitle: "profileImageDaySixth", image: selectedSixthDayImage)]
        
        return userImageData
    }
    
    func makeOnboardingCompleteData() -> ProfileEditUserAccount? {
        return ProfileEditUserAccount(educationType: makeEducationType()?.korean ?? "", educationDetail: schoolName, jobType: makeJobType()?.korean ?? "", jobDetail: jobDetail, address: makeLocation())
    }
    
    func makeRandomNumber() -> String {
        let unique = Array(0...9).shuffled().prefix(4)
        let uniqueString = unique.map { String($0) }
        return uniqueString.joined()
    }
    
    /// signup api에 보낼 데이터 만들기
    func makeSignupRequest() -> SignUpRequest? {
        guard let socialType = socialType?.rawValue, let socialId = socialId else { return nil }
        guard let locationSelected = locationSelected, let detailLocationSelected = detailLocationSelected else { return nil }
        
        let birthDate = makeBirthDate()
        let height = makeHeight()
        let selectedBefore = makeBeforePreference()
        let selectedAfter = makeAfterPreference()

        guard let educationType = makeEducationType()?.rawValue else { return nil }

        guard let jobType = makeJobType()?.type else { return nil }
        
        // 선택된 민감 정보 파악하기
        guard let lifeStyle = makeLifeStyle() else { return nil }
        let tempPhoneNumber1 = makeRandomNumber()
        let tempPhoneNumber2 = makeRandomNumber()
        let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        
        let signUpRequest = SignUpRequest(socialType: socialType, socialAccessToken: socialId, phoneNumber: "010-\(tempPhoneNumber1)-\(tempPhoneNumber2)", genderType: genderSelectedIndex == 0 ? "FEMALE" : "MALE", nickName: nicknameInput, birthDate: birthDate, height: height, districtRegion: locationSelected.addrName, cityRegion: detailLocationSelected.addrName, beforePreferenceTypeList: selectedBefore, afterPreferenceTypeList: selectedAfter, educationType: educationType, educationDetail: schoolName, jobType: jobType, jobDetail: jobDetail, lifeStyle: lifeStyle, introduction: "", fcmToken: fcmToken)
        
        return signUpRequest
    }
}

//MARK: - 프로필 수정일때만 사용
extension AccountViewModel {
    // 프로필 수정할 때 기존에 선택한 라이프스타일을 표시
    func applyUserLifeStyle(_ userLifeStyle: LifeStyle) {
        let mirror = Mirror(reflecting: userLifeStyle)
        for child in mirror.children {
            guard let category = child.label, let selectedType = child.value as? String else { continue }
            guard let choices = lifeStyleOriginalList[category] else { continue }
            
            if let idx = choices.firstIndex(where: { $0.korean == selectedType }) {
                if var buttonArray = lifeStyleButtonList[category] {
                    buttonArray = Array(repeating: false, count: buttonArray.count)
                    buttonArray[idx] = true
                    lifeStyleButtonList[category] = buttonArray
                }
            }
        }
    }
    
    func updateNickname() async {
        let updateNickname: [String : Any] = [
            PatchUserType.nickName.rawValue : nicknameInput,
                                                ]
        await patchUserAccountData(userPatchData: updateNickname)
    }
    
    /// 학력 업데이트
    func updateEducation() async {
        guard let educationType = makeEducationType() else { return }
        let updateEducation: [String : Any] = [
            PatchUserType.educationType.rawValue : educationType.rawValue,
            PatchUserType.educationDetail.rawValue : schoolName
                                                ]
        await patchUserAccountData(userPatchData: updateEducation)
    }
    
    /// 직업 업데이트
    func updateJob(jobType: String, jobDetail: String) async {
        guard let jobType = makeJobType() else { return }
        let udpateJobType: [String : Any] = [
            PatchUserType.jobType.rawValue : jobType.type,
            PatchUserType.jobDetail.rawValue : jobDetail
                                            ]
        await patchUserAccountData(userPatchData: udpateJobType)
    }
    
    /// 거주지 업데이트
    func updateLocation() async {
        var location = makeLocation()
        let updateLocation: [String : Any] = [
            PatchUserType.activeRegion.rawValue : location
        ]
        await patchUserAccountData(userPatchData: updateLocation)
    }
    
    /// 선호키워드 업데이트
    func updatePreference() async {
        var updatePreference: [String : Any] = [:]
        let selectedBefore = makeBeforePreference()
        let selectedAfter = makeAfterPreference()

        updatePreference = [
            PatchUserType.beforePreferenceTypeList.rawValue: selectedBefore,
            PatchUserType.afterPreferenceTypeList.rawValue: selectedAfter
        ]
        Log.debugPublic("selecte Before", updatePreference)
        await patchUserAccountData(userPatchData: updatePreference)
    }
    
    func updateLifeStyle() async {
        guard let lifeStyle = makeLifeStyle() else { return }
        let updateLifeStyle: [String : Any] = [
            PatchUserType.lifeStyle.rawValue : lifeStyle
        ]
        
        await patchUserAccountData(userPatchData: updateLifeStyle)
    }
    
    /// 자기소개 및 기본 이미지 업데이트
    func updateIntroduceAndDefaultImage() async {
        
        let updateIntroduceText: [String : Any] = [
            PatchUserType.introduction.rawValue : introduceText
        ]
        
        guard let selectedImage = selectedImage else { return }
        
        let userImageData: [AccountImage] = [AccountImage(imageTitle: "profileImage", image: selectedImage)]
        
        await patchUserAccountData(userPatchData: updateIntroduceText, userImage: userImageData)
    }
    
    /// 추가 이미지 업데이트
    func updateAdditionalImage() async {
        let updateDefaultData: [String : Any] = [:]
        
        var userImageData: [AccountImage] = []
        if let selectedSeconDayImage = selectedSeconDayImage {
            let secondImage = AccountImage(imageTitle: "profileImageDaySecond", image: selectedSeconDayImage)
            userImageData.append(secondImage)
        }
        if let selectedForthDayImage = selectedForthDayImage {
            let forthDayImage = AccountImage(imageTitle: "profileImageDayFourth", image: selectedForthDayImage)
            userImageData.append(forthDayImage)
        }
        
        if let selectedSixthDayImage = selectedSixthDayImage {
            let sixthDayImage = AccountImage(imageTitle: "profileImageDaySixth", image: selectedSixthDayImage)
            userImageData.append(sixthDayImage)
        }
        
        await patchUserAccountData(userPatchData: updateDefaultData, userImage: userImageData)
    }
}

//MARK: - 서버 통신 관련
extension AccountViewModel {
    /// 주소 데이터 가져오기
    /// - Parameters:
    ///   - code: 주소 코드
    ///   - isDetailLocation: 시/도 선택 후 구/군 정보 호출할때(시/도 선택 -> false, 구/군 선택 -> true)
    func fetchAddressData(code: String? = nil, isDetailLocation: Bool = false, selectedLocation: String? = nil, selectedDetailLocation: String? = nil) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await accountNetworkManger.fetchAddressData(code)
            switch result {
            case .success(let data):
                if isDetailLocation {
                    self.detailLocationOption = data.result
                } else {
                    self.locationOption = data.result
                }
                
                if let selectedLocation = selectedLocation {
                    self.locationSelected = data.result.first(where: { $0.addrName == selectedLocation })
                }
                
                if let selectedDetailLocation = selectedDetailLocation {
                    self.detailLocationSelected = data.result.first(where: { $0.addrName == selectedDetailLocation })
                }
                print(#fileID, #function, #line, "- self.locationOption: \(self.locationOption )")

                
            case .failure(let error):
                print(#fileID, #function, #line, "- failure: \(error.localizedDescription)")
            }
            
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
        }
    }

    
    /// 러브웨이 키워드 선택 API
    func fetchPreferenceType(preferenceType: PreferenceType, preferences: [String]? = nil) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        do {
            let result = try await accountNetworkManger.fetchPreferenceType(preferenceType.rawValue)
            switch result {
            case .success(let data):
                switch preferenceType {
                case .before:
                    if beforePreferenceTypes == data.result {
                        return
                    }
                    beforePreferenceTypes = data.result
                    isBeforePreferenceTypesSelected = Array(repeating: false, count: data.result.count)
                    
                    if let preferences = preferences {
                        isBeforePreferenceTypesSelected = data.result.map { preferences.contains($0.korean) }
                    }
                    
                    print(#fileID, #function, #line, "- preference data: \(isBeforePreferenceTypesSelected)")
                case .after:
                    if afterPreferceTypes == data.result {
                        return
                    }
                    afterPreferceTypes = data.result
                    isAfterPreferenceTypesSelected = Array(repeating: false, count: data.result.count)
                    if let preferences = preferences {
                        isAfterPreferenceTypesSelected = data.result.map { preferences.contains($0.korean) }
                    }
                }
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
        }
    }
    
    /// 직업 선택지 API
    func fetchJobType(selectedJobType: String? = nil) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await accountNetworkManger.fetchJobType()
            switch result {
            case .success(let data):
                if jobItmes == data.result {
                    return
                }
                jobItmes = data.result
                isJobButtonSelected = Array(repeating: false, count: data.result.count)
                if let selectedJobType = selectedJobType {
                    isJobButtonSelected = data.result.map { selectedJobType.contains($0.korean)}
                    selectedJobIndex = isJobButtonSelected.firstIndex(of: true)
                }
                Log.debugPublic("jobItems, isJobSelected, selectedIndex", jobItmes, isJobButtonSelected, selectedJobIndex)
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
        }
    }
    
    /// 민감정보데이터 받아오기(흡연, 음주, 타투, 종교)
    func fetchLifeStyle(lifeStyle: LifeStyle? = nil) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        do {
            let result = try await accountNetworkManger.fetchLifeStyleDatas()
            switch result {
            case .success(let lifeStyleResponse):
                lifeStyleResponse.lifeStyleList.forEach({ lifeStyleContent in
                    lifeStyleOriginalList[lifeStyleContent.category] = lifeStyleContent.choices
                    let koreanString = lifeStyleContent.choices.map { $0.korean }
                    lifeStyleList[lifeStyleContent.category] = koreanString
                })
                lifeStyleResponse.lifeStyleList.forEach({ lifeStyleContent in
                    let tempButton = Array(repeating: false, count: lifeStyleContent.choices.count)
                    lifeStyleButtonList[lifeStyleContent.category] = tempButton
                })
                if let lifeStyle = lifeStyle {
                    applyUserLifeStyle(lifeStyle)
                }
                
            case .failure(let error):
                Log.errorPublic("민감정보 데이터 받아오기 에러", error.localizedDescription)
            }
        } catch {
            Log.errorPublic("민감정보 데이터 받아오기 에러", error.localizedDescription)
        }
    }
    
    /// 유저 정보 저장하기
    func postUserData() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        Log.debugPublic("유저 정보 저장 호출")
        // 유저 정보 만들어주기
        guard let signupRequest = makeSignupRequest(), let userImageData = makeSignupImage() else {
            return
        }
        
        Log.debugPublic("유저 데이터", signupRequest)
        let identifier: String = UUID().uuidString
        let boundary: String = "Boundary-\(identifier)"
        
        let signupData = createUploadBody(request: signupRequest, images: userImageData, boundary: boundary)
        
        do {
            let result = try await accountNetworkManger.postUserData(requestModel: signupData, boundaryString: boundary)
            switch result {
            case .success(let result):
                Log.debugPublic("유저 정보 저장 성공", result)
                await appState.onAuthenticated()
            case .failure(let error):
                Log.networkPublic("유저 정보 저장 실패", error)
            }
        } catch {
            Log.errorPublic("유저 정보 저장 실패", error.localizedDescription)
        }
    }
    
    @MainActor
    func patchUserAccountData(userPatchData: [String : Any], userImage: [AccountImage] = []) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        let identifier: String = UUID().uuidString
        let boundary: String = "Boundary-\(identifier)"
        
       
        let patchAccountData = createUploadBody(request: userPatchData, images: [], boundary: boundary)
        
        do {
            let result = try await accountNetworkManger.patchUserData(requestModel: patchAccountData, boundaryString: boundary)
            
            switch result {
            case .success(let result):
                Log.debugPublic("유저 수정 성공", result)
            case .failure(let error):
                Log.errorPublic("유저 수정 실패", error)
            }
        } catch {
            Log.errorPublic("유저 수정 실패", error)
        }
    }
}

