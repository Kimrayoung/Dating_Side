//
//  Dating_SideApp.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/10.
//

import SwiftUI

@main
struct Dating_SideApp: App {
    @StateObject private var appState: AppState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
