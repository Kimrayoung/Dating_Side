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
    @EnvironmentObject var appState: AppState
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var pushNotificationManager = PushNotificationManager()
    @AppStorage("PushNotificationEnabled") private var isPushEnabled: Bool = true
    @State var showNotificationAlert: Bool = false
    
    var userImageURL: String?
    
    var body: some View {
        VStack {
            Text("내 계정")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                
            Button {
                
                appState.myPagePath.append(MyPage.profileEdit)
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
                .frame(height: 48)
            avoidPerson
                .frame(height: 48)
            ArrowNextRow(label: "계정", subTitle: nil, completion: {
                appState.myPagePath.append(MyPage.account)
            })
            ArrowNextRow(label: "이용약관", subTitle: nil, completion: {
                appState.myPagePath.append(MyPage.webView(url: "https://ivy-soapwort-586.notion.site/22280646722e80d3ba4cfe89d2270d51?source=copy_link"))
            })
            ArrowNextRow(label: "개인정보 처리방침", subTitle: nil, completion: {
                appState.myPagePath.append(MyPage.webView(url: "https://ivy-soapwort-586.notion.site/22280646722e809ba584f1828e663f74?source=copy_link"))
            })
            ArrowNextRow(label: "문의하기", subTitle: nil, completion: {
                appState.myPagePath.append(MyPage.webView(url: "https://ivy-soapwort-586.notion.site/22280646722e80d3ba4cfe89d2270d51?source=copy_link"))
            })
            Spacer()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                // 설정에서 돌아왔을 때 여기 들어옴
                pushNotificationManager.refresh()  // 알림 권한 상태 다시 확인
            }
        }
        .customAlert(isPresented: $showNotificationAlert, title: "알림은 설정에서 변경할 수 있습니다.", message: "설정으로 이동하시겠습니까?", primaryButtonText: "확인", primaryButtonAction: {
            pushNotificationManager.openNotificationSettings()
        }, secondaryButtonText: "취소")
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
        HStack {
            Text("푸시 알림 설정")
                .font(.pixel(16))
                .foregroundStyle(Color.blackColor)
            Spacer()
            Button(action: {
                showNotificationAlert.toggle()
            }, label: {
                Text(isPushEnabled ? "ON" : "OFF")
                    .foregroundStyle(isPushEnabled ? Color.mainColor : Color.gray3)
                    .font(.pixel(14))
            })
        }
        .padding(.horizontal, 24)
    }
    
    var avoidPerson: some View {
        HStack {
            Text("지인 피하기")
                .font(.pixel(16))
                .foregroundStyle(Color.blackColor)
            Spacer()
            Button(action: {
            }, label: {
                Text("ON")
                    .font(.pixel(14))
            })
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    SettingAndEditView(userImageURL: "https://picsum.photos/200/300")
}
