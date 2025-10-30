//
//  ReportView.swift
//  Dating_Side
//
//  Created by 안세훈 on 10/27/25.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm: ChatViewModel
    
    let reasons : [String] = ["불쾌한 언행", "불쾌한 이미지", "음란물 게시", "욕설/비방", "홍보 마케팅 등", "기타"]
    let roomId: String
    
    @State private var selectedReason: String? = nil
    @State private var commentText: String = ""
    
    init(roomId: String) {
        self.roomId = roomId
        _vm = StateObject(wrappedValue: ChatViewModel(roomId: roomId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("신고 사유를 선택해주세요.")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            reportReasonList
            
            if selectedReason == "기타" {
                commentInputView
                    .padding(.top, 16)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            reportButton
                .padding(.bottom, 20)
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
    
    
    // MARK: - 신고 사유 목록 View
    var reportReasonList: some View {
        VStack(spacing: 8) {
            ForEach(reasons, id: \.self) { reason in
                reportReasonButton(reason: reason)
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - 개별 신고 버튼
    func reportReasonButton(reason: String) -> some View {
        Button {
            selectedReason = reason
        } label: {
            Text(reason)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundStyle(selectedReason == reason ? Color.blue : Color.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(selectedReason == reason ? Color.blue : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedReason == reason ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    // MARK: - 텍스트 입력 영역 ('기타' 선택 시)
    var commentInputView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("사유를 입력해주세요.")
                .font(.system(size: 14))
                .foregroundStyle(Color.gray)
                .padding(.leading, 8)
            
            TextEditor(text: $commentText)
                .frame(height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 신고하기 버튼
    var reportButton: some View {
        Button(action: {
            // TODO: API 호출 로직 구현 (신고 사유와 코멘트 전송)
            print("신고 사유: \(selectedReason ?? "선택 안됨"), 코멘트: \(commentText)")
        }) {
            Text("신고하기")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: 250)
                .frame(height: 48)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(selectedReason == nil) // 사유를 선택하지 않으면 비활성화
        .padding(.horizontal, 24)
    }
}

#warning("preview")
#Preview {
    let dummyAppState = AppState()
    let previewRoomId = "PREVIEW_ROOM_123"
    
    NavigationStack {
        ReportView(roomId: previewRoomId)
            .environmentObject(dummyAppState)
    }
}
