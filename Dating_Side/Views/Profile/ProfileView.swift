//
//  ProfileView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/19.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    var simpleProfile: String
    var educationString: String
    var jobString: String
    var location: String
    var lifeStyle: LifeStyle?
    var keyword: String?
    var mannerTemperature: Int?
    var valueList: [String : [Answer]]
    var defaultImageUrl: String? = nil
    var onboardingDefaultImageData: UIImage? = nil
    var introduceText: String? = nil
    /// Profile을 보여주는 화면이 어디인지(mypage -> 내 프로필, chat -> 상대방 프로필, matching -> 상대방프로필)
    var showProfileViewType: ShowProfileViewType
    
    var body: some View {
        VStack(spacing: 16) {
            if showProfileViewType == .chat {
                Text("프로필")
                    .font(.pixel(16))
            }
            profile
            if showProfileViewType != .onboarding {
                manner
            }
            ScrollView(.horizontal) {
                HStack(content: {
                    defaultProfileInfo
                    sensitiveInfo
                })
            }
            .padding(.horizontal, 24)
            if showProfileViewType != .onboarding {
                valuesProfileInfo
            }
            selfTextView
        }
        
        
    }
    
    var profile: some View {
        HStack(spacing: 16, content: {
            if showProfileViewType == .onboarding {
                onboardingProfileImageView
            } else {
                profileImageView
            }
            simpleProfileView
        })
        .padding(.horizontal, 24)
    }
    
    var profileImageView: some View {
        Group {
            if let userProfileImage = defaultImageUrl {
                KFImage(URL(string: userProfileImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            } else {
                Image("defaultProfileImage")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            }
        }
    }
    
    var onboardingProfileImageView: some View {
        Group {
            if let userProfileImage = onboardingDefaultImageData {
                Image(uiImage: userProfileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            } else {
                Image("sampleImage")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            }
        }
    }
    
    var simpleProfileView: some View {
        VStack(spacing: 7, content: {
            HStack(content: {
                Text(simpleProfile)
                    .font(.pixel(16))
                
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            if showProfileViewType != .onboarding {
                Text(keyword ?? "")
                    .foregroundStyle(Color.mainColor)
                    .font(.pixel(12))
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.mainColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
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
            CustomRounedGradientProgressBar(currentProgress: mannerTemperature ?? 0, total: 100, barWidth: 345)
        })
    }
    
    var defaultProfileInfo: some View {
        VStack(spacing: 6, content: {
            makeDefaultProfileInfo(11, "지역", location)
            makeDefaultProfileInfo(11, "학력", educationString)
            makeDefaultProfileInfo(11, "직업", jobString)
        })
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(width: 205, height: 107)
        .background(Color.subColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var sensitiveInfo: some View {
        VStack(spacing: 3, content: {
            makeDefaultProfileInfo(4, "음주", lifeStyle?.drinking ?? "")
            makeDefaultProfileInfo(4, "흡연", lifeStyle?.smoking ?? "")
            makeDefaultProfileInfo(4, "타투", lifeStyle?.tattoo ?? "")
            makeDefaultProfileInfo(4, "종교", lifeStyle?.religion ?? "")
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
            appState.onboardingPath.append(OnChatProfilePath.profileValueList(valueType: valueType.korean, valueDataList: valueList[valueType.english] ?? []))
        } else if showProfileViewType == .myPage {
            appState.myPagePath.append(MyPage.profileValueList(valueType: valueType.korean, valueDataList: valueList[valueType.english] ?? []))
        }
    }
    
    var selfTextView: some View {
        VStack(content: {
            Text("자기소개")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: .constant(introduceText ?? ""))
                .font(.pixel(12)) // .pixel(12)이 커스텀 폰트라면 이렇게 적용
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .padding(.leading, 8)
                .background(Color.white)
                .disabled(true) // 편집 불가능하게
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )

                
        })
        .padding(.horizontal, 24)
    }
    
    
}

#Preview {
    ProfileView(simpleProfile: "라영/1999/163cm", educationString: "", jobString: "", location: "", valueList: [:], introduceText: "", showProfileViewType: .chat)
}
