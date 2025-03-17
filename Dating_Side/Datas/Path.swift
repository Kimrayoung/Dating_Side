//
//  Path.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

enum AppScreen {
    case onboarding
    case login
    case main
}

enum Onboarding {
    case genderSelect
    case nickname
    case birth
    case height
    case locationSelect
    case loveKeyword
    case keyword
    case education
    case susceptible
}

enum Main {
    case chat
    case setting
    case home
}

enum Login {
    case phoneNumber
    case verificationNumber
}

enum Path {
    case main
    case settingProfile
    case guide
    case myPage
}
