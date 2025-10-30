import SwiftUI
import Kingfisher

@MainActor
struct SettingAndEditView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var pushNotificationManager = PushNotificationManager()
    @StateObject var phoneContactVM = PhoneContactsViewModel()
    @AppStorage("PushNotificationEnabled") private var isPushEnabled: Bool = true
    @AppStorage("PhoneContactsAuthorization") private var isPhoneContactsEnable: Bool = true
    @AppStorage("AvoidanceEnable") private var avoidanceEnable: Bool = false
    @State var showNotificationAlert: Bool = false
    @State var showPhoneContactsAlert: Bool = false
    
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
        .task {
            // 권한 상태만 확인
            await phoneContactVM.checkAuthorizationOnly()
        }
        .customAlert(isPresented: $showNotificationAlert, title: "알림은 설정에서 변경할 수 있습니다.", message: "설정으로 이동하시겠습니까?", primaryButtonText: "확인", primaryButtonAction: {
            pushNotificationManager.openNotificationSettings()
        }, secondaryButtonText: "취소")
        .customAlert(isPresented: $showPhoneContactsAlert, title: "권한은 설정 > 개인정보 보호 > 연락처에서 변경 가능합니다.", message: "설정으로 이동하시겠습니까?", primaryButtonText: "확인", primaryButtonAction: {
            phoneContactVM.openAppSettings()
        }, secondaryButtonText: "취소")
        .onChange(of: avoidanceEnable) { _, avoidanceEnable in
            print(#fileID, #function, #line, "- avoidance 연락처 저장할건지 oldvalue: \(avoidanceEnable)")
            Task {
                if avoidanceEnable {
                    await phoneContactVM.requestAndLoad()
                } else {
                    Log.debugPublic("연락처 모두 삭제 시도")
                    await phoneContactVM.deleteAvoidanceList()
                }
            }
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
            // ✅ 토글 버튼으로 변경 - 사용자가 명시적으로 활성화
            Button(action: {
                if phoneContactVM.getSavedAuthorizationStatus() == nil {
                    // 아직 권한 요청 안 함 → 요청
                    Task {
                        await phoneContactVM.requestContactAuthorization()
                    }
                } else if !isPhoneContactsEnable {
                    // 권한 설정은 되어져 있지만 연락처 권한을 거절 -> 설정으로 이동할 건지 묻는 Alert
                    showPhoneContactsAlert.toggle()
                } else { // 연락처 가져올 수 있는 권한이 있음
                    avoidanceEnable = !avoidanceEnable
                }
            }, label: {
                Text(avoidanceEnable ? "ON" : "OFF")
                    .font(.pixel(14))
                    .foregroundStyle(
                        isPhoneContactsEnable ? Color.mainColor : Color.gray3
                    )
            })
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    SettingAndEditView(userImageURL: "https://picsum.photos/200/300")
        .environmentObject(AppState())
}

/*
 일단 들어오자마자 권한 설정 필요
 만약에 권한이 있으면 on/off 왔다갔다 가능
 on -> 지인피하기 가져와서 넣어주기
 off -> 지인 피하기 삭제
 만약에 권한이 없으면 권한 설정하라고 설정으로 이동
 */
