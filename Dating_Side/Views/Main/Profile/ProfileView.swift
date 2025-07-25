//
//  ProfileView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/19.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @Binding var selfIntroduceText: String
    var showProfileViewType: ShowProfileViewType
    
    var body: some View {
        VStack(spacing: 16) {
            Text("프로필")
                .font(.pixel(16))
                .padding(.top, 20)
            profile
            manner
            ScrollView(.horizontal) {
                HStack(content: {
                    defaultProfileInfo
                    sensitiveInfo
                })
            }
            .padding(.horizontal, 24)
            valuesProfileInfo
            selfTextView
        }
        
    }
    
    var profile: some View {
        HStack(spacing: 16, content: {
            Image("sampleImage")
                .resizable()
                .frame(width: 72, height: 72)
                .clipShape(Circle())
            VStack(spacing: 7, content: {
                HStack(content: {
                    Text("라영/1999/161cm")
                        .font(.pixel(16))
                    
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("친구처럼 편안한 연애")
                    .foregroundStyle(Color.mainColor)
                    .font(.pixel(12))
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.mainColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        })
    }
    
    var manner: some View {
        VStack(content: {
            HStack(spacing: 5, content: {
                Text("내 매너 지수")
                    .font(.pixel(13))
                    
                Image("caution")
                    .resizable()
                    .frame(width: 24, height: 24)
            })
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            CustomRounedGradientProgressBar(currentScreen: 10, total: 100, barWidth: 345)
        })
    }
    
    var defaultProfileInfo: some View {
        VStack(spacing: 6, content: {
            makeDefaultProfileInfo(11, "지역", "서울시 강남구")
            makeDefaultProfileInfo(11, "학력", "대학 재학 중 / 서울대학교")
            makeDefaultProfileInfo(11, "직업", "IT/개발, 네이버 개발자")
        })
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(width: 205, height: 107)
        .background(Color.subColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
    
    var sensitiveInfo: some View {
        VStack(spacing: 3, content: {
            makeDefaultProfileInfo(4, "음주", "가볍게 즐겨요")
            makeDefaultProfileInfo(4, "학력", "비흡연자에요")
            makeDefaultProfileInfo(4, "직업", "관심이있어요")
            makeDefaultProfileInfo(4, "종교", "관심이있어요")
        })
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(width: 150, height: 107)
        .background(Color.subColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    func makeDefaultProfileInfo(_ space: Int, _ title: String, _ info: String) -> some View {
        return HStack(spacing: 11, content: {
            Text(title)
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
            Text(info)
                .font(.pixel(12))
                .foregroundStyle(Color.black)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var valuesProfileInfo: some View {
        VStack(content: {
            Text("가치관 기록")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Button {
                    print(#fileID, #function, #line, "- 연애관으로 이동")
                    profilePathCheck(valueType: .couple)
                } label: {
                   makeValueProfileView(imageString: "loveView", text: "연애")
                }
                Button {
                    print(#fileID, #function, #line, "- 결혼관으로 이동")
                    profilePathCheck(valueType: .marry)
                } label: {
                    makeValueProfileView(imageString: "marryView", text: "결혼")
                }
                Button {
                    print(#fileID, #function, #line, "- 직장관으로 이동")
                    profilePathCheck(valueType: .company)
                } label: {
                    makeValueProfileView(imageString: "workView", text: "직장")
                }
                Button {
                    print(#fileID, #function, #line, "- 생활관으로 이동")
                    profilePathCheck(valueType: .life)
                } label: {
                    makeValueProfileView(imageString: "lifeView", text: "생활")
                }
            }
        })
        .padding(.horizontal, 24)
    }
    
    func makeValueProfileView(imageString: String, text: String) -> some View {
        return ZStack {
            Text(text)
                .font(.pixel(12))
                .foregroundStyle(Color.white)
            Image(imageString)
                .resizable()
                .frame(width: 80, height: 80)
        }
        .background(Color.mainColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    func profilePathCheck(valueType: ProfileValueType) {
        if showProfileViewType == .chat {
            appState.onChatProfilePath.append(OnChatProfilePath.profileValueList(valueType: valueType))
        }
    }
    
    var selfTextView: some View {
        VStack(content: {
            Text("자기소개")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $selfIntroduceText)
                .font(.pixel(12))
                .padding(8) // 내부 여백
                .background(Color.white) // 배경색 (필수: 테두리가 잘 보이게)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .frame(height: 200)
        })
        .padding(.horizontal, 24)
    }
    
    
}

#Preview {
    ProfileView(selfIntroduceText: .constant("hihih"), showProfileViewType: .chat)
}
