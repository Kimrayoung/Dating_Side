//
//  Navigation.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import Foundation

class Navigation: NSObject, ObservableObject, NavigationProtocol {
    @Published var path: [Path]
    
    init(presentRoutes: [Path] = []) {
        self.path = presentRoutes
    }
}
