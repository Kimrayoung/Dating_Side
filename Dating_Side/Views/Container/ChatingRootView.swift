//
//  ChatingRootView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/24/25.
//

import SwiftUI

struct ChatingRootView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationStack(path: $appState.chatPath) {
            ChatListView()
                .navigationDestination(for: Chating.self) { step in
                    switch step {
                    case .chatList: ChatListView()
                    case let .chatRoom(roomId, partnerName, partnerImageUrl):
                        ChatingView(roomId: roomId, partnerName: partnerName, partnerImageUrl: partnerImageUrl)
                    }
                }
        }
        
    }
}
