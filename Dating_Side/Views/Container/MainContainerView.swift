//
//  MainContainerView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct MainContainerView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationStack(path: $appState.mainPath) {
            ChatListView()
        }
    }
}

#Preview {
    MainContainerView()
}
