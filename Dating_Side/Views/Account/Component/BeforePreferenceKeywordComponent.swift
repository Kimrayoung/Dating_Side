//
//  BeforePreferenceKeywordComponent.swift
//  Dating_Side
//
//  Created by 김라영 on 8/4/25.
//

import SwiftUI

struct BeforePreferenceKeywordComponent: View {
    @ObservedObject var viewModel: AccountViewModel
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        VStack {
            Text("러브웨이를 만나기 전\n어떤 사랑을 해왔나요?")
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
                ForEach(Array(viewModel.beforePreferenceTypes.enumerated()), id: \.element) { (index, item) in
                    selectBtn(item.korean, index)
                }
            })
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 23)
    }
    
    func selectBtn(_ word: String, _ index: Int) -> some View {
        return Button(action: {
            viewModel.isBeforePreferenceTypesSelected[index].toggle()
        }, label: { SelectButtonLabel(isSelected: $viewModel.isBeforePreferenceTypesSelected[index], height: 52, text: word, backgroundColor: .white, selectedBackgroundColor: .subColor, selectedTextColor: .black ,cornerRounded: 6, strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor) })
    }
}
