//
//  ProfileMiniView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

struct ProfileMiniView: View {
    var isDefault: Bool
    var body: some View {
        VStack {
            Image("defaultProfileImage")
                .resizable()
                .frame(width: 79.65, height: 79.65)
            Text("운명의 상대")
                .font(.pixel(17.7))
            Text("따뜻하게 배려하는 연애")
                .font(.pixel(13.28))
                .foregroundStyle(Color.mainColor)
                .padding(10)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.mainColor, lineWidth: 1.11)
                })
        }
        .padding(.vertical, 19.76)
        .padding(.horizontal, 17.54)
        .background(Color.white)
        
    }
}

#Preview {
    ProfileMiniView(isDefault: true)
}
