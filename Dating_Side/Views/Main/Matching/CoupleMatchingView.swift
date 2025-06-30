//
//  CoupleMatchingView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/24.
//

import SwiftUI
import Kingfisher

@MainActor
struct CoupleMatchingView: View {
    var userProfile: TomeUserProfile = TomeUserProfile(userName: "윈터", userImage: "https://picsum.photos/200/300", userType: "")
    var userProfile2: TomeUserProfile = TomeUserProfile(userName: "윈터", userImage: "https://picsum.photos/id/1/200/300", userType: "")
    var userProfile3: TomeUserProfile = TomeUserProfile(userName: "윈터", userImage: "https://picsum.photos/id/2/200/300", userType: "")
    var userProfile4: TomeUserProfile = TomeUserProfile(userName: "윈터", userImage: "https://picsum.photos/id/3/200/300", userType: "")
    var message: UserMessage = UserMessage(message: "안녕하세요", time: Date())
    var body: some View {
        VStack(content: {
            simpleProfile
            dateDay
            ZStack(content: {
                sixthDayImage
                forthDayImage
                secondDayImage
                firstDay
            })
            Spacer()
        })
    }
    
    var simpleProfile: some View {
        HStack {
            if let image = URL(string: userProfile.userImage) {
                KFImage(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            } else {
                Image("defaultProfileImage")
                    .resizable()
                    .frame(width: 72, height: 72)
            }
            
            VStack(spacing: 4) {
                Text(userProfile.userName)
                    .font(.pixel(16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                Text(message.message)
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 13)
            
            Text("\(message.time.hourAndMinuteString)")
                .padding(.vertical, 13)
                .padding(.bottom, 23)
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }
    
    var dateDay: some View {
        VStack {
            Text("\(userProfile.userName)과 매칭 된 지 1일차")
                .font(.pixel(20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("상대의 의미있는 순간들 입니다:) 깊은 대화에 도움이 될거에요.")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.bottom, .horizontal], 24)
    }
    
    var firstDay: some View {
        RoundedRectangle(cornerRadius: 9.57)
            .fill(Color.mainColor)
            .frame(width: 224, height: 368)
            .overlay {
                Text("2일차부터\n상대의 사진이 보여요")
                    .foregroundStyle(Color.white)
                    .font(.pixel(16))
                    .padding(.trailing, 70)
            }
    }
    
    var secondDayImage: some View {
        Group {
            Button {
                print(#fileID, #function, #line, "- <#comment#>")
            } label: {
                if let image = URL(string: userProfile2.userImage) {
                    KFImage(image)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 9.57))
                        .padding(.leading, 16)
                } else {
                    Image("checkerImage")
                        .frame(width: 240, height: 360)
                        .padding(.leading, 16)
                }
            }
        }
    }
    
    var forthDayImage: some View {
        Group {
            Button {
                print(#fileID, #function, #line, "- <#comment#>")
            } label: {
                if let image = URL(string: userProfile3.userImage) {
                    KFImage(image)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 9.57))
                        .padding(.leading, 32)
                } else {
                    RoundedRectangle(cornerRadius: 9.57)
                        .fill(Color.subColor)
                        .frame(width: 240, height: 360)
                        .padding(.leading, 32)
                }
            }
        }
    }
    
    var sixthDayImage: some View {
        Group {
            Button {
                print(#fileID, #function, #line, "- <#comment#>")
            } label: {
                if let image = URL(string: userProfile4.userImage) {
                    KFImage(image)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 9.57))
                        .padding(.leading, 48)
                } else {
                    RoundedRectangle(cornerRadius: 9.57)
                        .fill(Color.subColor1)
                        .frame(width: 240, height: 360)
                        .padding(.leading, 48)
                }
            }
        }
    }
    
}

#Preview {
    CoupleMatchingView()
}
