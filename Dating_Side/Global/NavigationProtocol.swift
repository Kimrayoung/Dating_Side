//
//  NavigationProtocol.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import Foundation

protocol NavigationProtocol: NSObjectProtocol {
    var path: [Path] { get set }
    
    func push(to newRoute: Path)
    func pop()
    func setRoute(to newRote: Path)
}

extension NavigationProtocol {
    //MARK: - 다음으로 넘어가기
    func push(to newRoute: Path) {
        self.path.append(newRoute)
    }

    //MARK: - 이전화면으로
    func pop() {
        DispatchQueue.main.async {

            self.path.removeLast()
        }
    }

    //MARK: - 특정화면으로 넘어가기
    func setRoute(to newRoute: Path) {
        self.path = [newRoute]
    }
    
    //MARK: - rootView로 돌아가기
    func popToRoot() {
        self.path.removeAll()
    }
}
