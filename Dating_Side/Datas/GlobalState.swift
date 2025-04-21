//
//  GlobalState.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import Foundation

let onboardingPageCnt: Int = 10

public protocol OneDigitalTextField: Hashable, Equatable {
    var index: Int? { get }
}
