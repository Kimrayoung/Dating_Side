//
//  AfterPreferenceKeywordComponent.swift
//  Dating_Side
//
//  Created by 김라영 on 8/4/25.
//

import SwiftUI

struct AfterPreferenceKeywordComponent: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        VStack {
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
            gridView
        }
    }
    
    
    var gridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10, content: {
                ForEach(Array(viewModel.afterPreferceTypes.enumerated()), id: \.element) { (index, item) in
                    selectBtn(item.korean, index)
                }
            })
        }
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
    AfterPreferenceKeywordComponent(viewModel: AccountViewModel())
}
