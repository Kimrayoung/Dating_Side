//
//  OnChatProfileView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/07/02.
//

import SwiftUI

struct OnChatProfileView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack(path: $appState.onChatProfilePath) {
            VStack {
                ProfileView(userData: viewModel.userData, simpleProfile: viewModel.makeSimpleProfile(), educationString: viewModel.makeSchoolString(), jobString: viewModel.makeJobString(), valueList: viewModel.userValueList, showProfileViewType: .chat)
                HStack(spacing: 5, content: {
                    skipButton
                    okButton
                })
                .padding(.horizontal, 24)
            }
            .customAlert(isPresented: $showAlert, title: "이 분을 영영 볼 수 없어도 괜찮나요?", message: "대화 해보면 잘 맞을지도 몰라요", primaryButtonText: "다시 봐볼게요", primaryButtonAction: {}, secondaryButtonText: "괜찮아요", secondaryButtonAction: {})
            .navigationDestination(for: OnChatProfilePath.self) { step in
                switch step {
                case .profileMain: OnChatProfileView(viewModel: viewModel)
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
    OnChatProfileView()
}
