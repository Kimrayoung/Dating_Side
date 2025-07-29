//
//  MainContainerView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct MainContainerView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selection = 0
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.init(hex: "#CBD8FB")
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack(path: $appState.chatPath) {
                ChatingView()
            }
            .tabItem {
                Label("채팅", image: selection == 0 ? "chatSelected" : "chatNotSelected")
                    .font(.pixel(8))
            }
            .tag(0)
            NavigationStack(path: $appState.matchingPath) {
                MatchingRootView()
            }
            .tabItem {
                Label("매칭", image: selection == 1 ? "matchSelected" : "matchNotSelected")
                    .font(.pixel(8))
            }
            .tag(1)
            NavigationStack(path: $appState.myPagePath) {
                MyPageRootView()
            }
            .tabItem {
                Label("마이페이지", image: selection == 2 ? "mypageSelected" : "mypageNotSelected")
                    .font(.pixel(8))
            }
            .tag(2)
        }
        .tint(.mainColor)
    }
}

#Preview {
    MainContainerView()
}
