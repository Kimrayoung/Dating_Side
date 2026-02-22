//
//  MainContainerView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct MainContainerView: View {
    @EnvironmentObject private var appState: AppState
//    @State private var selection = 0
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.init(hex: "#CBD8FB")
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack(path: $appState.chatPath) {
                ChatingRootView()
            }
            .tabItem {
                Label("채팅", image: appState.selectedTab == .chat ? "chatSelected" : "chatNotSelected")
                    .font(.pixel(8))
            }
            .tag(TabType.chat)
            NavigationStack(path: $appState.matchingPath) {
                MatchingRootView()
            }
            .tabItem {
                Label("매칭", image: appState.selectedTab == .matching ? "matchSelected" : "matchNotSelected")
                    .font(.pixel(8))
            }
            .tag(TabType.matching)
            NavigationStack(path: $appState.myPagePath) {
                MyPageRootView()
            }
            .tabItem {
                Label("마이페이지", image: appState.selectedTab == .myPage ? "mypageSelected" : "mypageNotSelected")
                    .font(.pixel(8))
            }
            .tag(TabType.myPage)
        }
        .tint(.mainColor)
    }
}

#Preview {
    MainContainerView()
}
