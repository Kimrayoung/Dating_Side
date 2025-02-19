//
//  GenderSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import SwiftUI

struct GenderSelectView: View {
    @State private var selectedIndex: Int? = 0
    @State private var possibleNext: Bool = false
    let genderOption = ["여자", "남자"]
    var body: some View {
        VStack(content: {
            Text("성별을 알려주세요")
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            Spacer()
            CustomPicker(selectedIndex: $selectedIndex,
                         items: genderOption.enumerated().map { index, value in
                CustomPickerItem(id: index, value: value)
            },
                         itemHeight: 40, menuHeightMultiplier: 5) // 여기서 높이 조절
            .frame(height: 500)
            .padding(20)
            Spacer()
            Button(action: {}, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .blackColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
        })
        
    }
}

#Preview {
    GenderSelectView()
}


