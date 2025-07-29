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
class AccountViewModel: ObservableObject {
    private var appState = AppState.shared
    let accountNetworkManger = AccountNetworkManager()
    private var cancellables = Set<AnyCancellable>()
    let loadingManager = LoadingManager.shared
    
    var isOnboarding: Bool = false
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
    
    /// 위치 정보 만들기
    func makeLocation() -> String {
        return locationOption[locationSelectedIndex].addrName + "/" + detailLocationOption[detailLocationSelectedIndex].addrName
    }
    
    /// 민감정보 만들기
    func makeLifeStyle() -> LifeStyle? {
        guard let drunkIndex = lifeStyleButtonList["drinking"]?.firstIndex(of: true) else { return nil }
        guard let smokeIndex = lifeStyleButtonList["smoking"]?.firstIndex(of: true) else { return nil }
        guard let tattoIndex = lifeStyleButtonList["tattoo"]?.firstIndex(of: true) else { return nil }
        guard let religionIndex = lifeStyleButtonList["religion"]?.firstIndex(of: true) else { return nil }
        guard let drunkTextOptions = lifeStyleOriginalList["drinking"] else { return nil }
        guard let smokeTextOptions = lifeStyleOriginalList["smoking"] else { return nil }
        guard let tattoTextOptions = lifeStyleOriginalList["tattoo"] else { return nil }
        guard let religionTextOptions = lifeStyleOriginalList["religion"] else { return nil }
        
        return LifeStyle(drinking: drunkTextOptions[drunkIndex].type, smoking: smokeTextOptions[smokeIndex].type, tattoo: tattoTextOptions[tattoIndex].type, religion: religionTextOptions[religionIndex].type)
    }
    
    /// signup api에 보낼 데이터 만들기
    func makeSignupRequest() -> SignUpRequest? {
        guard let socialType = socialType?.rawValue, let socialId = socialId else { return nil }
        let location = makeLocation()
        let birthDate = makeBirthDate()
        let height = makeHeight()
        let selectedBefore = zip(beforePreferenceTypes, isBeforePreferenceTypesSelected)
            .compactMap { (type, isSelected) in
                isSelected ? type.type : nil
            }
        let selectedAfter = zip(afterPreferceTypes, isAfterPreferenceTypesSelected)
            .compactMap { (type, isSelected) in
                isSelected ? type.type : nil
            }

        guard let selectedEducationIndex = selectedEducationIndex else { return nil }
        guard let selectedJobIndex = selectedJobIndex else { return  nil }
        
        // 선택된 민감 정보 파악하기
        guard let lifeStyle = makeLifeStyle() else { return nil }

        let signUpRequest = SignUpRequest(socialType: socialType, socialAccessToken: socialId, phoneNumber: "010-1155-3585", genderType: genderSelectedIndex == 0 ? "FEMALE" : "MALE", nickName: nicknameInput, birthDate: birthDate, height: height, activeRegion: location, beforePreferenceTypeList: selectedBefore, afterPreferenceTypeList: selectedAfter, educationType: education[selectedEducationIndex].rawValue, educationDetail: schoolName, jobType: jobItmes[selectedJobIndex].type, jobDetail: jobDetail, lifeStyle: lifeStyle, introduction: "", fcmToken: "socialId")
        
        return signUpRequest
    }
    
    /// singup API에 보낼 이미지(유저 이미지)
    func makeSignupImage() -> [AccountImage]? {
        guard let selectedImage = selectedImage, let selectedSeconDayImage = selectedSeconDayImage, let selectedForthDayImage = selectedForthDayImage, let selectedSixthDayImage = selectedSixthDayImage else { return nil }
        
        let userImageData: [AccountImage] = [AccountImage(imageTitle: "profileImage", image: selectedImage), AccountImage(imageTitle: "profileImageDaySecond", image: selectedSeconDayImage), AccountImage(imageTitle: "profileImageDayFourth", image: selectedForthDayImage), AccountImage(imageTitle: "profileImageDaySixth", image: selectedSixthDayImage)]
        
        return userImageData
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
    func loadSelectedImage(imageType: ImageType, pickerItem: PhotosPickerItem) {
        pickerItem.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        // 압축/리사이즈 적용 (예: 1024픽셀 기준, 품질 0.7)
                        let reducedImage: UIImage
                        if let resizedData = image.resizedAndCompressedJPEGData(toWidth: 1024, quality: 0.2),
                           let resizedImage = UIImage(data: resizedData) {
                            reducedImage = resizedImage
                        } else {
                            reducedImage = image
                        }
                        switch imageType {
                        case .mainProfile:
                            self.selectedImage = reducedImage
                        case .secondDay:
                            self.selectedSeconDayImage = reducedImage
                        case .forthDay:
                            self.selectedForthDayImage = reducedImage
                        case .sixthDay:
                            self.selectedSixthDayImage = reducedImage
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
    /// 주소 데이터 가져오기
    func fetchAddressData(isFirstLoading: Bool = false, code: String? = nil, isDetailLocation: Bool = false) async {
        loadingManager.isLoading = true
        
        let signpost = httpTimeLog.fetchLocationData
                         .makeSignpost(name: #function, object: self)
        
        signpost.begin("code: %d, firstLoading: %d detail: %d", code ?? "nil", String(isFirstLoading), String(isDetailLocation))

        defer { signpost.end() }
        
        do {
            let result = try await accountNetworkManger.fetchAddressData(code)
            switch result {
            case .success(let data):
                if isDetailLocation {
                    self.detailLocationOption = data
                    loadingManager.isLoading = false
                    return
                } else {
                    self.locationOption = data
                    loadingManager.isLoading = false
                }
                
                print(#fileID, #function, #line, "- self.locationOption: \(self.locationOption )")
                
                if isFirstLoading, let first = data.first {
                    print(#fileID, #function, #line, "- firstLocation: \(first)")
                    await self.fetchAddressData(
                      isFirstLoading: false,
                      code: first.code,
                      isDetailLocation: true
                    )
                }
                
            case .failure(let error):
                print(#fileID, #function, #line, "- failure: \(error.localizedDescription)")
                loadingManager.isLoading = false
            }
            
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            loadingManager.isLoading = false
        }
    }

    
    /// 러브웨이 키워드 선택 API
    func fetchPreferenceType(preferenceType: PreferenceType) async {
        loadingManager.isLoading = true
        do {
            let result = try await accountNetworkManger.fetchPreferenceType(preferenceType.rawValue)
            switch result {
            case .success(let data):
                switch preferenceType {
                case .before:
                    if beforePreferenceTypes == data {
                        loadingManager.isLoading = false
                        return
                    }
                    beforePreferenceTypes = data
                    isBeforePreferenceTypesSelected = Array(repeating: false, count: data.count)
                    print(#fileID, #function, #line, "- preference data: \(data)")
                case .after:
                    if afterPreferceTypes == data {
                        loadingManager.isLoading = false
                        return
                    }
                    afterPreferceTypes = data
                    isAfterPreferenceTypesSelected = Array(repeating: false, count: data.count)
                }
                loadingManager.isLoading = false
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                loadingManager.isLoading = false
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            loadingManager.isLoading = false
        }
    }
    
    /// 직업 선택지 API
    func fetchJobType() async {
        loadingManager.isLoading = true
        do {
            let result = try await accountNetworkManger.fetchJobType()
            switch result {
            case .success(let data):
                if jobItmes == data {
                    loadingManager.isLoading = false
                    return
                }
                jobItmes = data
                isJobButtonSelected = Array(repeating: false, count: data.count)
                loadingManager.isLoading = false
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                loadingManager.isLoading = false
            }
        } catch {
            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
            loadingManager.isLoading = false
        }
    }
    
    /// 민감정보데이터 받아오기(흡연, 음주, 타투, 종교)
    func fetchLifeStyle() async {
        loadingManager.isLoading = true
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
                loadingManager.isLoading = false
            case .failure(let error):
                print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                loadingManager.isLoading = false
            }
        } catch {
            loadingManager.isLoading = false
        }
    }
    
    /// 유저 정보 저장하기
    func postUserData() async -> Bool{
        loadingManager.isLoading = true
        Log.debugPublic("유저 정보 저장 호출")
        // 유저 정보 만들어주기
        guard let signupRequest = makeSignupRequest(), let userImageData = makeSignupImage() else {
            loadingManager.isLoading = false
            return false
        }
        
        
        Log.debugPublic("유저 데이터", signupRequest)
        let identifier: String = UUID().uuidString
        let boundary: String = "Boundary-\(identifier)"
        
        let signupData = createUploadBody(request: signupRequest, images: userImageData, boundary: boundary)
        
        do {
            let result = try await AccountNetworkManager().postUserData(requestModel: signupData, boundaryString: boundary)
            switch result {
            case .success(let result):
                Log.debugPublic("유저 정보 저장 성공", result)
                loadingManager.isLoading = false
                return true
            case .failure(let error):
                Log.networkPublic("유저 정보 저장 실패", error)
                loadingManager.isLoading = false
                return false
            }
        } catch {
            Log.errorPublic("유저 정보 저장 실패", error.localizedDescription)
            loadingManager.isLoading = false
            return false
        }
    }
}

