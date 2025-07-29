//
//  LoadingManager.swift
//  Dating_Side
//
//  Created by 김라영 on 7/27/25.
//

import SwiftUI
import Combine

final class LoadingManager: ObservableObject {
    static let shared = LoadingManager()
    @Published var isLoading: Bool = false

    private init() {}
}
