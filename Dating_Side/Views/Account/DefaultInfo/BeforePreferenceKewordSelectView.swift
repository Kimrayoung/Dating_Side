//
//  LoveKeywordSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/18.
//

import SwiftUI

struct BeforePreferenceKewordSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    var preferences: [String] = []

    var body: some View {
        VStack(spacing: 0) {
            EmptyView()
                .padding(.top, 30)
            CustomRounedGradientProgressBar(currentProgress: 6, total: onboardingPageCnt)
            BeforePreferenceKeywordComponent(viewModel: viewModel)
            Button(action: {
                if !viewModel.isBeforePreferenceTypeComplete {
                    return
                }
                let selectedBefore = zip(viewModel.beforePreferenceTypes, viewModel.isBeforePreferenceTypesSelected)
                    .compactMap { (type, isSelected) in
                        isSelected ? type : nil
                    }
                Log.debugPublic("선택지 확인", selectedBefore)
                appState.onboardingPath.append(Onboarding.afterPreference)
//                if viewModel.isOnboarding {
//                    
//                } else {
//                    Task {
//                        await viewModel.updatePreference(preferenceType: .before)
//                    }
//                }
//                
            }, label: {
                SelectButtonLabel(isSelected: $viewModel.isBeforePreferenceTypeComplete, height: 48, text: "다음" , backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .task {
            viewModel.setupBeforePreferenceBindings()
            await viewModel.fetchPreferenceType(preferenceType: .before, preferences: preferences)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
}

#Preview {
    BeforePreferenceKewordSelectView(viewModel: AccountViewModel())
}
