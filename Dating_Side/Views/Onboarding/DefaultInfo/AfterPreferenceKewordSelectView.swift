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
    
    @State private var isBefore: Bool = true
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 5, total: onboardingPageCnt)
                .padding(.top, 30)
            Text(isBefore ? "러브웨이를 만나기 전\n어떤 사랑을 해왔나요?" : "이제 러브웨이에서 어떤 사랑을 하고 싶나요?")
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
                SelectButtonLabel(isSelected: $viewModel.isAfterPreferenceTypeComplete, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .task {
            viewModel.setupBeforePreferenceBindings()
            await viewModel.fetchPreferenceType(preferenceType: .after)
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
            ForEach(Array(viewModel.afterPreferceTypes.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index)
            }
        })
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 23)
    }
    
    func selectBtn(_ word: String, _ index: Int) -> some View {
        return Button(action: {
            viewModel.isAfterPreferenceTypesSelected[index].toggle()
        }, label: { SelectButtonLabel(isSelected: $viewModel.isAfterPreferenceTypesSelected[index], height: 52, text: word, backgroundColor: .white, selectedBackgroundColor: .subColor, selectedTextColor: .black ,cornerRounded: 6, strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor) })
    }
    
}

#Preview {
    AfterPreferenceKewordSelectView(viewModel: AccountViewModel())
}
