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
}
