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

    var body: some View {
        VStack(spacing: 0) {
            EmptyView()
                .padding(.top, 30)
            CustomRounedGradientProgressBar(currentProgress: 6, total: onboardingPageCnt)
            Text("러브웨이를 만나기 전\n어떤 사랑을 해왔나요?")
                .font(.pixel(24))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 48)
            Text("끌리는 키워드를 최대 7개까지 선택해주세요")
                .font(.pixel(14))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 36)
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
            }, label: {
                SelectButtonLabel(isSelected: $viewModel.isBeforePreferenceTypeComplete, height: 48, text: "다음" , backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .task {
            viewModel.setupBeforePreferenceBindings()
            await viewModel.fetchPreferenceType(preferenceType: .before)
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
