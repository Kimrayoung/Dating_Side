//
//  ReportView.swift
//  Dating_Side
//
//  Created by 안세훈 on 10/27/25.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject private var appState: AppState
    @ObservedObject var vm: ChatViewModel
    
    let roomId: String
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .navigationTitle("신고하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        appState.chatPath.removeLast()
                    } label: {
                        Image("navigationBackBtn")
                    }
                }
            })
    }
}

#warning("preview")
#Preview {
    let dummyVM = ChatViewModel(roomId: "PREVIEW_ROOM_123")
    let dummyAppState = AppState()
    
    NavigationStack {
        // 💡 뷰 모델 인스턴스를 매개변수로 직접 주입
        ReportView(vm: dummyVM, roomId: "123")
            .environmentObject(dummyAppState) // EnvironmentObject 주입
    }
}
