//
//  MatchingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 7/20/25.
//

import Combine
import Foundation

class MatchingViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var questions: [String] = []
}
