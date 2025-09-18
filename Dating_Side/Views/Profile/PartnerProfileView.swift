//
//  PartnerProfileView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/07/02.
//

import SwiftUI

struct PartnerProfileView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var matchingViewModel: MatchingViewModel = MatchingViewModel()
    @State private var showAlert: Bool = false
    @State private var valueList: [String : [Answer]] = [:]
    @State var matchingPartnerAccount: PartnerAccount? = nil
    @State var showToastPopup: Bool = false
    @Binding var profileShow: Bool
    var needMathcingRequest: PartnerProfileViewType
    var matchingPartnerTempAccount: PartnerAccount? = nil
    
    var body: some View {
        NavigationStack(path: $appState.onChatProfilePath) {
            VStack {
                ProfileView(
                    simpleProfile: matchingViewModel.makeSimpleProfile(matchingPartnerAccount: matchingPartnerAccount) ,
                    educationString: matchingViewModel.makeSchoolString(matchingPartnerAccount: matchingPartnerAccount),
                    jobString: matchingViewModel.makeJobString(matchingPartnerAccount: matchingPartnerAccount),
                    location: matchingPartnerAccount?.activeRegion ?? "",
                    lifeStyle: matchingPartnerAccount?.lifeStyle,
                    keyword: matchingPartnerAccount?.keyword,
                    valueList: valueList,
                    defaultImageUrl: matchingPartnerAccount?.profileImageURL,
                    introduceText: matchingPartnerAccount?.introduction,
                    showProfileViewType: .chat)
                .padding(.top, 30)
                Spacer()
                if needMathcingRequest == .matching || needMathcingRequest == .chattingRequestMatch {
                    HStack(spacing: 5, content: {
                        skipButton
                        okButton
                    })
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
            .task {
                // 내 아이디를 통해서 매칭 상대를 찾아야 함(매칭할 수 있는 상대의 데이터를 보내줌)
                if needMathcingRequest == .matching {
                    // 매칭된 상대방의 프로필 조회(매칭 성사 x) ->즉, 매칭가능한 상대방을 찾음
                    matchingPartnerAccount = await matchingViewModel.matchingRequest()
                } else if needMathcingRequest == .matchComplete {
                    // 매칭 성사된
                    matchingPartnerAccount = await matchingViewModel.matchingPartner()
                } else {
                    matchingPartnerAccount = matchingPartnerTempAccount
                    Log.debugPublic("matching partner checking", matchingPartnerTempAccount)
                }
                
                if matchingPartnerAccount == nil {
                    profileShow = false
                    appState.matchingPath.append(Matching.matchingProfileCheckView)
                }
            }
            .customAlert(isPresented: $showAlert, title: "이 분을 다시 만나지 못할 수 있어요", message: "상대방의 매력을 다시 확인해볼까요?", primaryButtonText: "괜찮아요", primaryButtonAction: {
                showAlert = false
                profileShow = false // 프로필 모달 자체를 내림
                appState.matchingPath.append(Matching.matchingFail)
            }, secondaryButtonText: "다시 봐볼께요", secondaryButtonAction: {
                showAlert = false
            })
            .customToastPopup(isPresented: $showToastPopup, title: "\(matchingPartnerAccount?.nickName ?? "")과 매칭에 성공했습니다", message: "채팅방이 열렸습니다.")
            .navigationDestination(for: OnChatProfilePath.self) { step in
                switch step {
                case .profileMain: PartnerProfileView(profileShow: $profileShow, needMathcingRequest: needMathcingRequest)
                case .profileValueList(let valueType, let valueDataList):
                    ValuesListView(valueType: valueType, valueDataList: valueDataList)
                }
            }
        }
        
    }
    
    var skipButton: some View {
        Button(action: {
            showAlert = true
        }, label: {
            Text("좋은 인연 만나세요")
                .font(.pixel(16))
                .foregroundStyle(Color.gray3)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(Color.gray0)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        })
    }
    
    var okButton: some View {
        Button(action: {
            Task {
                if needMathcingRequest == .chattingRequestMatch { // 내게 다가온 사람이랑 매칭
                    guard let partnerId = matchingPartnerAccount?.id else { return }
                    await matchingViewModel.matchingComplete(partnerId: partnerId)
                } else if needMathcingRequest == .matching { // 내가 다가가기(즉, 매칭 요청)
                    let result = await matchingViewModel.attraction(matchingPartnerAccount: matchingPartnerAccount)
                    if result {
                        
                    }
                }
            }
        }, label: {
            Text("대화 해볼래요")
                .font(.pixel(16))
                .foregroundStyle(Color.whiteColor)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(Color.mainColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        })
    }
}

#Preview {
    PartnerProfileView(profileShow: .constant(false), needMathcingRequest: .chattingRequestMatch, matchingPartnerTempAccount: nil)
}
