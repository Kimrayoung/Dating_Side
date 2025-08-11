//
//  OnChatProfileView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/07/02.
//

import SwiftUI

struct OnChatProfileView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject var matchingViewModel: MatchingViewModel = MatchingViewModel()
    @State private var showAlert: Bool = false
    @State private var valueList: [String : [Answer]] = [:]
    @Binding var profileShow: Bool
    
    var body: some View {
        NavigationStack(path: $appState.onChatProfilePath) {
            VStack {
                ProfileView(
                    simpleProfile: matchingViewModel.makeSimpleProfile() ,
                    educationString: matchingViewModel.makeSchoolString(),
                    jobString: matchingViewModel.makeJobString(),
                    location: matchingViewModel.matchingPartnerAccount?.activeRegion ?? "",
                    valueList: valueList,
                    defaultImageUrl: matchingViewModel.matchingPartnerAccount?.profileImageURL,
                    introduceText: matchingViewModel.matchingPartnerAccount?.introduction,
                    showProfileViewType: .chat)
                HStack(spacing: 5, content: {
                    skipButton
                    okButton
                })
                .padding(.horizontal, 24)
            }
            .task {
                await matchingViewModel.matchingRequest()
            }
            .customAlert(isPresented: $showAlert, title: "이 분을 다시 만나지 못할 수 있어요", message: "상대방의 매력을 다시 확인해볼까요?", primaryButtonText: "괜찮아요", primaryButtonAction: {
                appState.matchingPath.append(Matching.questionComplete)
            }, secondaryButtonText: "다시 봐볼께요", secondaryButtonAction: {
                profileShow = false
            })
            .navigationDestination(for: OnChatProfilePath.self) { step in
                switch step {
                case .profileMain: OnChatProfileView(profileShow: $profileShow)
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
                await matchingViewModel.attraction()
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
    OnChatProfileView(profileShow: .constant(false))
}
