//
//  LoveKeywordSelectView2.swift
//  Dating_Side
//
//  Created by 김라영 on 7/14/25.
//

import SwiftUI

struct AfterPreferenceKewordSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            EmptyView()
                .padding(.top, 30)
            CustomRounedGradientProgressBar(currentProgress: 7, total: onboardingPageCnt)
            TextWithColoredSubString(
                text: "이제 러브웨이에서\n어떤 사랑을 하고 싶나요?",
                highlight: "러브웨이",
                gradientColors: [.mainColor]
            )
            .font(.pixel(24))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 48)
            Text("끌리는 키워드를 최대 7개까지 선택해주세요")
                .font(.pixel(14))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 36)
            AfterPreferenceKeywordComponent(viewModel: viewModel)
            
            Button(action: {
                if !viewModel.isAfterPreferenceTypeComplete {
                    return
                }
                let selectedBefore = zip(viewModel.afterPreferceTypes, viewModel.isAfterPreferenceTypesSelected)
                    .compactMap { (type, isSelected) in
                        isSelected ? type : nil
                    }
                Log.debugPublic("선택지 확인", selectedBefore)
                appState.onboardingPath.append(Onboarding.education)
//                if viewModel.isOnboarding {
//
//                } else {
//                    Task {
//                        await viewModel.updatePreference(preferenceType: .before)
//                    }
//                }
            }, label: {
                SelectButtonLabel(isSelected: $viewModel.isAfterPreferenceTypeComplete, height: 48, text: "다음" , backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .task {
            viewModel.setupAfterPreferenceBindings()
            await viewModel.fetchPreferenceType(preferenceType: .after)
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
    AfterPreferenceKewordSelectView(viewModel: AccountViewModel())
}
