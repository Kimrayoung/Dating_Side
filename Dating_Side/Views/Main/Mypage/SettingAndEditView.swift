//
//  SettingAndEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/30.
//

import SwiftUI
import Kingfisher

@MainActor
struct SettingAndEditView: View {
    var userImageURL: String?
    var body: some View {
        VStack {
            Text("내 계정")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                
            Button {
                
            } label: {
                profileEditView
            }
            .frame(height: 112)
            Rectangle()
                .frame(height: 4)
                .opacity(0.1)
            Text("설정")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                .padding(.top, 16)
            pushNoti
                .padding(.vertical, 32)
            avoidPerson
                .padding(.bottom, 32)
            ArrowNextRow(label: "게정", subTitle: nil, completion: {
                
            })
            .padding(.bottom, 32)
            ArrowNextRow(label: "이용약관", subTitle: nil, completion: {
                
            })
            .padding(.bottom, 32)
            ArrowNextRow(label: "개인정보 처리방침", subTitle: nil, completion: {
                
            })
            .padding(.bottom, 32)
            ArrowNextRow(label: "문의하기", subTitle: nil, completion: {
                
            })
            .padding(.bottom, 32)
            Spacer()
        }
    }
    
    var profileEditView: some View {
        HStack {
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
            VStack {
                Text("프로필 편집")
                    .font(.pixel(16))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("지역, 학력, 직업, 라이프 스타일, 프로필")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image("rightArrow")
        }
        .padding(.horizontal, 24)
    }
    
    var pushNoti: some View {
        Button(action: {
            
        }, label: {
            HStack(content: {
                Text("푸시 알림 설정")
                    .font(.pixel(16))
                    .foregroundStyle(Color.blackColor)
                Spacer()
                Image("rightArrow")
            })
        })
        .padding(.horizontal, 24)
    }
    
    var avoidPerson: some View {
        Button(action: {
            
        }, label: {
            HStack(content: {
                Text("지인 피하기")
                    .font(.pixel(16))
                    .foregroundStyle(Color.blackColor)
                Spacer()
                Image("rightArrow")
            })
        })
        .padding(.horizontal, 24)
    }
}

#Preview {
    SettingAndEditView(userImageURL: "https://picsum.photos/200/300")
}
