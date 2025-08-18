//
//  ProfileMiniView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI
import Kingfisher

struct ProfileMiniView: View {
    var isDefault: Bool
    var userImageURL: String?
    var userName: String = ""
    var userType: String = ""
    var widthSize: CGFloat = 180
    var heightSize: CGFloat = 180
    
    var body: some View {
        VStack {
            if let imageURL = userImageURL {
                KFImage(URL(string: imageURL))
                    .resizable()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            } else {
                Image("defaultProfileImage")
                    .resizable()
                    .frame(width: 72, height: 72)
                    
            }
            Text(isDefault ? "운명의 상대" : userName)
                .font(.pixel(16))
            Text(isDefault ? "따뜻하게 배려하는 연애" : userType)
                .font(.pixel(12))
                .foregroundStyle(Color.mainColor)
                .padding(10)
                .frame(maxWidth: .infinity)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.mainColor, lineWidth: 1.11)
                })
        }
        .padding(.vertical, 19)
        .padding(.horizontal, 17)
        .frame(width: widthSize, height: heightSize)
        .background(Color.white)
        
    }
}

#Preview {
    ProfileMiniView(isDefault: true, userImageURL: "https://picsum.photos/200/300", userName: "", userType: "")
}
