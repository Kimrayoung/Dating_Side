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
            
            Text("신고 사유를 선택해주세요.")
                .font(.rounded(15))
                .foregroundStyle(Color.gray3)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
                .padding(.bottom, 22)
                .frame(alignment: .center)
            
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
                .font(.rounded(15))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(selectedReason == reason ? Color.subColor : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedReason == reason ? Color.mainColor : Color.gray0, lineWidth: 2)
                )
        }
    }
    
    // MARK: - 텍스트 입력 영역 ('기타' 선택 시)
    var commentInputView: some View {
        ZStack(alignment: .topLeading) {
            
            TextEditor(text: $commentText)
                .scrollContentBackground(.hidden)
                .frame(height: 180)
                .padding(EdgeInsets(top: 4, leading: 5, bottom: 0, trailing: 0))
                .background(Color(hex: "#eaeff6"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text("사유를 입력해주세요.")
                .font(.rounded(15))
                .foregroundStyle(Color.gray01)
                .padding(EdgeInsets(top: 13, leading: 13, bottom: 0, trailing: 0))
                .opacity(commentText.isEmpty ? 1 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 신고하기 버튼
    var reportButton: some View {
        Button(action: {
            // TODO: API 호출 로직 구현 (신고 사유와 코멘트 전송)
            print("신고 사유: \(selectedReason ?? "선택 안됨"), 코멘트: \(commentText)")
            vm.userReport(reason: selectedReason ?? commentText)
        }) {
            Text("신고하기")
                .font(.rounded(16))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: 250)
                .frame(height: 48)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(selectedReason == nil)
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
