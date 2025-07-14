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
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 5, total: onboardingPageCnt)
                .padding(.top, 30)
            Text("러브웨이를 만나기 전\n어떤 사랑을 해왔나요?")
                .font(.pixel(24))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 48)
            Text("끌리는 키워드를 최대 7개까지 선택해주세요")
                .font(.pixel(14))
                .foregroundStyle(Color.mainColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 36)
            gridView
            
            Button(action: {
                appState.onboardingPath.append(Onboarding.education)
            }, label: {
                SelectButtonLabel(isSelected: $viewModel.isBeforePreferenceTypeComplete, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
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
//            ToolbarItem(placement: .principal) {
//                CustomProgressBar(progress: 3, total: onboardingPageCnt)
//            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 10, content: {
            ForEach(Array(viewModel.beforePreferenceTypes.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index)
            }
        })
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 23)
    }
    
    func selectBtn(_ word: String, _ index: Int) -> some View {
        return Button(action: {
            viewModel.isBeforePreferenceTypesSelected[index].toggle()
        }, label: { SelectButtonLabel(isSelected: $viewModel.isBeforePreferenceTypesSelected[index], height: 52, text: word, backgroundColor: .white, selectedBackgroundColor: .subColor, selectedTextColor: .black ,cornerRounded: 6, strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor) })
    }
    
}

#Preview {
    BeforePreferenceKewordSelectView(viewModel: AccountViewModel())
}
