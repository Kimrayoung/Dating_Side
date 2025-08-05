//
//  BirthUnitLabel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

// 단위 텍스트 (년, 월, 일) 컴포넌트
struct UnitLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.pixel(10))
            .frame(maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.leading, 2)
    }
}
