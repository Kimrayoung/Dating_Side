//
//  NoticeView.swift
//  Dating_Side
//
//  Created by 안세훈 on 11/20/25.
//

import SwiftUI

struct NoticeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationTitle("알림")
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

#Preview {
    NoticeView()
        .environmentObject(DummyAppState())
    
}
