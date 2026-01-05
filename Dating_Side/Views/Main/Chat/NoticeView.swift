//
//  NoticeView.swift
//  Dating_Side
//
//  Created by 안세훈 on 11/20/25.
//

import SwiftUI

struct NoticeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AccountViewModel()
    
    var body: some View {
        VStack {
            if viewModel.userNotificationList.isEmpty {
                Spacer()
                Text("새로운 알림이 없습니다.")
                    .font(.rounded(16))
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: []) {
                        ForEach(groupedNotifications, id: \.0) { (title, items) in
                            Text(title)
                                .font(.rounded(16))
                                .foregroundColor(.gray3)
                                .padding(.leading, 24)
                                .padding(.top, 24)
                                .padding(.bottom, 8)
                            
                            ForEach(items, id: \.sentAt) { notification in
                                NotificationRow(notification: notification)
                                    .padding(.horizontal, 24)
                            }
                        }
                    }
                    .padding(.bottom, 20) // 스크롤 끝부분 여백
                }
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.chatPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        }
        .task {
            await viewModel.getNotificationLog()
        }
    }
    
    var groupedNotifications: [(String, [NotificationResponse])] {
        let notifications = viewModel.userNotificationList
        
        let grouped = Dictionary(grouping: notifications) { noti -> String in
            return noti.sentAt.toDate?.sectionCategory ?? "기타"
        }
        
        let targetOrder = ["오늘", "7일", "이전"]
        
        return targetOrder.compactMap { key in
            guard let items = grouped[key] else { return nil }
            
            let sortedItems = items.sorted {
                ($0.sentAt.toDate ?? Date()) > ($1.sentAt.toDate ?? Date())
            }
            return (key, sortedItems)
        }
    }
}

struct NotificationRow: View {
    let notification: NotificationResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.body)
                .font(.rounded(16))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            if let date = notification.sentAt.toDate {
                Text(date.relativeString)
                    .font(.rounded(12))
                    .foregroundColor(.gray3)
            }
        }
        .padding(.vertical, 16)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    NoticeView()
        .environmentObject(DummyAppState())
    
}
