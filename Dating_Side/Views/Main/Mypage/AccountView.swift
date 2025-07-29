//
//  AccoutView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/30.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAccountDeleteAlert: Bool = false
    @State private var showLogoutAlert: Bool = false
    
    var body: some View {
        VStack(content: {
            logoutButton
            Rectangle()
                .fill(Color.gray0)
                .frame(height: 1)
            quitButton
            Rectangle()
                .fill(Color.gray0)
                .frame(height: 1)
            changePhone
            Rectangle()
                .fill(Color.gray0)
                .frame(height: 1)
            Spacer()
        })
        .navigationTitle("계정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            
        })
        .customAlert(isPresented: $showAccountDeleteAlert, title: "회원 탈퇴 시\n모든 정보가 삭제됩니다", message: "정말 러브웨이를 떠나시겠습니까?", primaryButtonText: "취소", primaryButtonAction: {}, primaryButtonColor: .red, secondaryButtonText: "회원탈퇴", secondaryButtonAction: {
            Task {
                await appState.accountDelete()
            }
        }, secondaryButtonColor: .gray3)
        .customAlert(isPresented: $showLogoutAlert, title: "다시 로그인 하면\n원래대로 돌아옵니다", message: "잠시 로그아웃 하시겠습니까?", primaryButtonText: "취소", primaryButtonAction: {}, primaryButtonColor: .red, secondaryButtonText: "로그아웃", secondaryButtonAction: {
            Task {
                await appState.logout()
          }
        }, secondaryButtonColor: .gray3)
    }
    
    var logoutButton: some View {
        Text("로그아웃")
            .font(.pixel(16))
            .foregroundStyle(Color.black)
            .frame(height: 48)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 24)
            .contentShape(Rectangle())
            .onTapGesture {
                showLogoutAlert = true
            }
    }
    
    var quitButton: some View {
        Text("회원탈퇴")
            .font(.pixel(16))
            .foregroundStyle(Color.black)
            .frame(height: 48)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 24)
            .contentShape(Rectangle())
            .onTapGesture {
                showAccountDeleteAlert = true
            }
            
    }
    
    var changePhone: some View {
        Button {
            
        } label: {
            Text("전화번호 변경")
                .font(.pixel(16))
                .foregroundStyle(Color.black)
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
    }
}

#Preview {
    AccountView()
}
