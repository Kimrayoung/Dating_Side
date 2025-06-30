//
//  AccoutView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/30.
//

import SwiftUI

struct AccoutView: View {
    var body: some View {
        VStack(content: {
            logoutButton
                .padding(.vertical, 24)
            Rectangle()
                .fill(Color.gray0)
                .frame(height: 1)
            quitButton
                .padding(.vertical, 24)
            Rectangle()
                .fill(Color.gray0)
                .frame(height: 1)
            changePhone
                .padding(.vertical, 24)
            Rectangle()
                .fill(Color.gray0)
                .frame(height: 1)
            Spacer()
        })
        .navigationTitle("계정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            
        })
    }
    
    var logoutButton: some View {
        Button {
            
        } label: {
            Text("로그아웃")
                .font(.pixel(16))
                .foregroundStyle(Color.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
    }
    
    var quitButton: some View {
        Button {
            
        } label: {
            Text("회원탈퇴")
                .font(.pixel(16))
                .foregroundStyle(Color.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
    }
    
    var changePhone: some View {
        Button {
            
        } label: {
            Text("전화번호 변경")
                .font(.pixel(16))
                .foregroundStyle(Color.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
    }
}

#Preview {
    AccoutView()
}
