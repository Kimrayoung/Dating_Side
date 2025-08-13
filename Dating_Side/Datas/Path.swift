//
//  Path.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

/// 앱 처음 들어왔을 때 어떤 뷰 보여줘야 하는지
enum AppScreen {
    case onboarding(SocialType, String)
    case login
    case main
}

enum Onboarding: Hashable {
    /// 핸드폰 번호 입력
    case phoneNumber
    /// 인증코드 입력
    case verifySMSCode
    case genderSelect
    case nickname
    case birth
    case height
    case locationSelect
    case beforePreference
    case afterPreference
    case education
    case schoolName
    case job
    case jobDetail
    case susceptible
    /// 채팅 프로필 (프로필 사진, 자기소개)
    case chatProfileImage
    /// 추가사진 - 2일차
    case secondDayPhoto
    /// 추가사진 - 4일차
    case forthDayPhoto
    /// 추가사진 - 6일차
    case sixthDayPhoto
    case onboardingComplete
    case profileEdit(userData: ProfileEditUserAccount)
    case editEducation
    case editJob
    case editPreference
}

enum Main {
    case chat
    case matching
    case mypage
}

enum MyPage: Hashable {
    case mypage
    case settingProfile(userImageURL: String?)
    case profileValueList(valueType: String, valueDataList: [Answer]) // Changed for ProfileView type match
    case profileEdit
    case account
    case defaultProfileImage
    case nicknameInput(nickname: String?)
    case locationSelect(location: String?)
    case job(jobType: String?, jobDetail: String?)
    case education(educationType: String?, schoolName: String?)
    case preferences(beforeKeywords: [String], afterKeywords: [String])
    case susceptible(lifeStyle: LifeStyle)
    case webView(url: String)
}

enum Matching: Hashable {
    case questionList
    case questionAnswer
    case questionComplete
    case matchingFail
    case matchingSecondProfile
    /// 답변완료시 메인 화면
    case answerCompleteMain
}

enum Path {
    case main
    case settingProfile
    case guide
    case myPage
    case proflile
}

///채팅방에서 프로필 보기를 했을때의 경로
enum OnChatProfilePath: Hashable {
    case profileMain
    case profileValueList(valueType: String, valueDataList: [Answer]) // Changed for ProfileView type match
}
